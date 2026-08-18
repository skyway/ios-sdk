//
//  RoomViewModel.swift
//  Tutorial
//
//  Copyright © 2025 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import Foundation
import SkyWayRoom

@MainActor
final class RoomViewModel: ObservableObject, RoomDelegate {
    @Published var localVideoStream: LocalVideoStream?
    @Published var remoteVideoStream: RemoteVideoStream?
    private var localAudioStream: LocalAudioStream?

    private var room: Room?
    private var localRoomMember: LocalRoomMember?

    func start(roomName: String) async {
        let appId = "アプリケーションIDを入力してください"
        let secretKey = "シークレットキーを入力してください"
        // SkyWayのセットアップ
        let contextOptions: ContextOptions = .init()
        contextOptions.logLevel = .trace
        try? await Context.setupForDev(withAppId: appId, secretKey: secretKey, options: contextOptions)

        // Roomの作成
        let roomInit: Room.InitOptions = .init()
        roomInit.name = roomName
        guard let room = try? await Room.findOrCreate(with: roomInit) else {
            print("[Tutorial] Creating room failed.")
            return
        }
        self.room = room

        // Roomへの参加
        let memberInit: Room.MemberInitOptions = .init()
        memberInit.name = "member_\(UUID().uuidString)"
        guard let member = try? await room.join(with: memberInit) else {
            print("[Tutorial] Join failed.")
            return
        }
        localRoomMember = member

        // カメラからの映像取得とUIへの表示
        // カメラリソースの取得
        if let camera = CameraVideoSource.supportedCameras().first(where: { $0.position == .front }) {
            // カメラ映像のキャプチャを開始します
            try? await CameraVideoSource.shared().startCapturing(with: camera, options: nil)
        } else {
            print("[Tutorial] Supported camera is not found.")
        }
        // 描画やPublishが可能なStreamを作成します
        // @Publishedプロパティを更新し、ContentViewのLocalVideoViewで描画します
        localVideoStream = CameraVideoSource.shared().createStream()

        // マイクからの音声取得
        // Publishが可能なStreamを作成します
        localAudioStream = MicrophoneAudioSource().createStream()

        // StreamのPublish
        _ = try? await member.publish(localVideoStream!, options: nil)
        _ = try? await member.publish(localAudioStream!, options: nil)

        // Room内でStreamがPublishされるとroom(_:didPublishStreamOf:)が呼ばれるようにdelegateを登録します
        room.delegate = self

        // PublicationのSubscribe
        // 入室時に他のMemberのPublicationをSubscribeします
        for publication in room.publications {
            await subscribe(publication)
        }
    }

    // Room内のMemberがPublishしているPublicationをSubscribeします
    private func subscribe(_ publication: RoomPublication) async {
        // 自身のPublicationは除く
        if publication.publisher == localRoomMember {
            return
        }
        // PublicationをSubscribeします
        guard let subscription = try? await localRoomMember?.subscribe(publicationId: publication.id, options: nil) else {
            return
        }
        // Videoの場合はremoteVideoStreamを更新して描画します
        if let videoStream = subscription.stream as? RemoteVideoStream {
            self.remoteVideoStream = videoStream
        }
    }

    // MARK: - RoomDelegate

    nonisolated func room(_ room: Room, didPublishStreamOf publication: RoomPublication) {
        Task {
            await subscribe(publication)
        }
    }
}

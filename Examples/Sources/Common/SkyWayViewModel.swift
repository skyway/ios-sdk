//
//  SkyWayViewModel.swift
//
//  Created by Naoto Takahashi on 2022/12/26.
//  Copyright © 2025 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import SkyWayRoom

class SkyWayViewModel: NSObject, ObservableObject, RoomDelegate, RemoteDataStreamDelegate {
    var room: Room?
    var localMember: LocalRoomMember?
    var dataStream: LocalDataStream?
    var isAutoSubscribing: Bool = false
    let highEncodeId: String = "high"
    let lowEncodeId: String = "low"

    @Published var remotePublications: [RoomPublication] = []
    @Published var localSubscriptions: [RoomSubscription] = []
    @Published var receivedMessage: String = ""
    
    lazy var currentEncoding: String = highEncodeId
    
    var isJoined: Bool {
        get {
           return localMember != nil
        }
    }
    
    func setup() async throws {
        let appId = "アプリケーションIDを入力してください"
        let secretKey = "シークレットキーを入力してください"
        let opt: ContextOptions = .init()
        opt.logLevel = .trace
        try await Context.setupForDev(withAppId: appId, secretKey: secretKey, options: opt)
        let backCamera = CameraVideoSource.supportedCameras().first(where: { $0.position == .back })
        if let backCamera = backCamera {
            try await CameraVideoSource.shared().startCapturing(with: backCamera, options: nil)
        }
    }
    
    func joinRoom(roomName: String, roomType: RoomType) async throws -> String {
        let opt: Room.InitOptions = .init()
        opt.name = roomName
        let memberOpt: Room.MemberInitOptions = .init()
        if roomType == .P2P {
            let room = try await P2PRoom.findOrCreate(with: opt)
            DispatchQueue.main.sync {
                remotePublications = room.publications
            }
            let localMember = try await room.join(with: memberOpt)
            self.room = room
            room.delegate = self
            self.localMember = localMember
        }else {
            let room = try await SFURoom.findOrCreate(with: opt)
            DispatchQueue.main.sync {
                remotePublications = room.publications
            }
            let localMember = try await room.join(with: memberOpt)
            self.room = room
            room.delegate = self
            self.localMember = localMember
        }
        return self.localMember!.id
    }
    
    func leave() async throws {
        // イベントの購読を停止
        room?.delegate = nil
        dataStream = nil
        try await localMember?.leave()
        DispatchQueue.main.sync {
            remotePublications = []
            localSubscriptions = []
            receivedMessage = ""
        }
        // SDK内部で管理しているRoomを破棄
        try? await room?.dispose()
        localMember = nil
        room = nil
    }
    
    func publishStreams(includeDataStream: Bool = true) async throws {
        // AudioStream
        let audioStream = MicrophoneAudioSource().createStream()
        // VideoStream
        let videoStream = CameraVideoSource.shared().createStream()
        let audioPublicationOptions: RoomPublicationOptions = .init()
        let _ = try await localMember?.publish(audioStream, options: audioPublicationOptions)
        let videoPublicationOptions: RoomPublicationOptions = .init()
        if room is SFURoom {
            // lowEnc is not in use.
            //let lowEnc: Encoding = .init()
            //lowEnc.id = lowEncodeId
            //lowEnc.scaleResolutionDownBy = 8.0
            let highEnc: Encoding = .init()
            highEnc.id = highEncodeId
            highEnc.scaleResolutionDownBy = 1.0
            videoPublicationOptions.encodings = [ highEnc ]
        }else {
            let enc: Encoding = .init()
            enc.scaleResolutionDownBy = 1.0
            videoPublicationOptions.encodings = [ enc ]
        }
        let _ = try await localMember?.publish(videoStream, options: videoPublicationOptions)
        if room is P2PRoom && includeDataStream {
            // DataStream
            dataStream = DataSource().createStream()
            let _ = try await localMember?.publish(dataStream!, options: nil)
        }
    }
    
    func subscribe(publication: RoomPublication) async throws -> RoomSubscription? {
        guard  publication.publisher != localMember else{
            return nil
        }
        guard let localMember = localMember else {
            return nil
        }
        let opt: SubscriptionOptions = .init()
        let sub = try await localMember.subscribe(publicationId: publication.id, options: opt)
        if let dataStream = sub.stream as? RemoteDataStream {
            dataStream.delegate = self
        }
        DispatchQueue.main.sync {
            localSubscriptions.append(sub)
        }
        return sub
    }
    
    func unsubscribe(subscriptionId: String) async throws {
        try await localMember?.unsubscribe(subscriptionId: subscriptionId)
        DispatchQueue.main.sync {
            localSubscriptions.removeAll(where: { $0.id == subscriptionId })
        }
    }
    
    func sendMessage(_ message: String) {
        guard let dataStream = dataStream else {
            return
        }
        dataStream.write(message)
    }
    
    func changePreferredEncoding(subscriptionId: String, encodingId: String) {
        guard let sub = room?.subscriptions.first(where: { $0.id == subscriptionId }) else {
            print("[App] Subscription is missing")
            return
        }
        sub.changePreferredEncoding(encodingId: encodingId)
    }
    
    func toggleVideoEncoding(roomType: RoomType) {
        guard let videoPub = localMember?.publications.first(where: { $0.contentType == .video }) else {
            return
        }
        let newEncoding: Encoding = .init()
        if currentEncoding == highEncodeId {
            newEncoding.scaleResolutionDownBy = 8.0
            currentEncoding = lowEncodeId
        }else {
            newEncoding.scaleResolutionDownBy = 1.0
            currentEncoding = highEncodeId
        }
        videoPub.update([ newEncoding ])
        print("[App] Encodings updated")
    }
    
    // MARK: - RoomDelegate
    func room(_ room: Room, didPublishStreamOf publication: RoomPublication) {
        guard let localMember = localMember else {
            return
        }
        if publication.publisher != localMember {
            if isAutoSubscribing {
                Task {
                    // `subscribe(publicationId:options:)`の返り値のsubscriptionではstreamが取得できるため、これをviewに伝える。
                    guard let sub = try? await localMember.subscribe(publicationId: publication.id, options: nil) else {
                        return
                    }
                    DispatchQueue.main.sync {
                        localSubscriptions.append(sub)
                    }
                }
            }
        }
    }
    
    func room(_ room: Room, didUnsubscribePublicationOf subscription: RoomSubscription) {
        DispatchQueue.main.sync {
            localSubscriptions.removeAll(where: { $0 == subscription })
        }
    }
    
    func roomPublicationListDidChange(_ room: Room) {
        DispatchQueue.main.sync {
            remotePublications = room.publications.filter({ $0.publisher != localMember })
        }
    }
    
    // MARK: - RemoteDataStreamDelegate
    func dataStream(_ dataStream: RemoteDataStream, didReceive string: String) {
        DispatchQueue.main.sync {
            receivedMessage = string
        }
    }
}

extension ContentType {
    func toString() -> String {
        switch self {
        case .audio:
            return "Audio"
        case .video:
            return "Video"
        case .data:
            return "Data"
        @unknown default:
            fatalError()
        }
    }
}

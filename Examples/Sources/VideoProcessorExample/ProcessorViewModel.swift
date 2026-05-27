//
//  ProcessorViewModel.swift
//  VideoProcessorExample
//
//  Copyright © 2026 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import SwiftUI
import SkyWayRoom
import Vision
import UIKit

@MainActor
class ProcessorViewModel: NSObject, ObservableObject, RoomDelegate {

    // MARK: - Published state

    @Published var isJoined: Bool = false
    @Published var isPublished: Bool = false
    @Published var isBusy: Bool = false
    @Published var isSetup: Bool = false
    @Published var errorMessage: String? = nil

    // BlurProcessor の設定
    @Published var blurEnabled: Bool = false {
        didSet { syncBlurProcessor() }
    }
    @Published var blurRadius: Float = 20 {
        didSet { blurProcessor.blurRadius = blurRadius }
    }
    @Published var blurInferenceInterval: UInt8 = 2 {
        didSet { blurProcessor.inferenceInterval = blurInferenceInterval }
    }
    @Published var blurQuality: VNGeneratePersonSegmentationRequest.QualityLevel = .balanced {
        didSet { blurProcessor.qualityLevel = blurQuality }
    }

    // VirtualBackgroundProcessor の設定
    @Published var vbEnabled: Bool = false {
        didSet { syncVirtualBackgroundProcessor() }
    }
    @Published var vbInferenceInterval: UInt8 = 2 {
        didSet { virtualBackgroundProcessor.inferenceInterval = vbInferenceInterval }
    }
    @Published var vbQuality: VNGeneratePersonSegmentationRequest.QualityLevel = .balanced {
        didSet { virtualBackgroundProcessor.qualityLevel = vbQuality }
    }
    /// 現在セットされている背景画像（nil = 未設定）
    @Published var vbBackgroundImage: UIImage? = nil {
        didSet { virtualBackgroundProcessor.backgroundImage = vbBackgroundImage }
    }

    // MARK: - Private

    @available(iOS 15.0, *)
    private lazy var blurProcessor = BlurProcessor()
    @available(iOS 15.0, *)
    private lazy var virtualBackgroundProcessor = VirtualBackgroundProcessor()

    private var room: Room?
    private var localMember: LocalRoomMember?

    // MARK: - Setup

    func setup() async throws {
        isBusy = true
        defer { isBusy = false }
        let appId = "アプリケーションIDを入力してください"
        let secretKey = "シークレットキーを入力してください"
        let opt: ContextOptions = .init()
        opt.logLevel = .trace
        try await Context.setupForDev(withAppId: appId, secretKey: secretKey, options: opt)

        let frontCamera = CameraVideoSource.supportedCameras().first(where: { $0.position == .front })
        let camera = frontCamera ?? CameraVideoSource.supportedCameras().first
        if let camera {
            try await CameraVideoSource.shared().startCapturing(with: camera, options: nil)
        }
        isSetup = true
    }

    // MARK: - Room join / leave

    func joinRoom(roomName: String) async throws {
        isBusy = true
        defer { isBusy = false }

        let opt: Room.InitOptions = .init()
        opt.name = roomName
        let room = try await Room.findOrCreate(with: opt)
        room.delegate = self

        let memberOpt: Room.MemberInitOptions = .init()
        let localMember = try await room.join(with: memberOpt)

        self.room = room
        self.localMember = localMember
        isJoined = true
    }

    func publishStreams() async throws {
        guard let localMember else { return }
        isBusy = true
        defer { isBusy = false }

        // Audio
        let audioSource: MicrophoneAudioSource = .init()
        let audioStream = audioSource.createStream()
        let _ = try await localMember.publish(audioStream, options: nil)

        // Video: setup() で startCapturing 済みのため createStream() のみ
        let videoStream = CameraVideoSource.shared().createStream()
        let videoOpt: RoomPublicationOptions = .init()
        let enc: Encoding = .init()
        enc.scaleResolutionDownBy = 1.0
        videoOpt.encodings = [enc]
        videoOpt.type = .P2P
        let _ = try await localMember.publish(videoStream, options: videoOpt)

        isPublished = true
    }

    func leaveRoom() async throws {
        room?.delegate = nil
        try await localMember?.leave()
        try? await room?.dispose()
        room = nil
        localMember = nil
        isJoined = false
        isPublished = false

        // プロセッサをリセット
        if #available(iOS 15.0, *) {
            blurProcessor.isActive = false
            virtualBackgroundProcessor.isActive = false
        }
        blurEnabled = false
        vbEnabled = false
    }

    // MARK: - Processor sync

    private func syncBlurProcessor() {
        guard #available(iOS 15.0, *) else { return }
        let videoSource = CameraVideoSource.shared()
        if blurEnabled {
            // VirtualBackground と排他: 両方同時には使わない
            vbEnabled = false
            virtualBackgroundProcessor.isActive = false
            // 既存のプロセッサを外してから新しいものを追加
            videoSource.remove(virtualBackgroundProcessor)
            blurProcessor.isActive = true
            videoSource.add(blurProcessor)
        } else {
            blurProcessor.isActive = false
            videoSource.remove(blurProcessor)
        }
    }

    private func syncVirtualBackgroundProcessor() {
        guard #available(iOS 15.0, *) else { return }
        let videoSource = CameraVideoSource.shared()
        if vbEnabled {
            // BlurProcessor と排他
            blurEnabled = false
            blurProcessor.isActive = false
            videoSource.remove(blurProcessor)
            virtualBackgroundProcessor.isActive = true
            videoSource.add(virtualBackgroundProcessor)
        } else {
            virtualBackgroundProcessor.isActive = false
            videoSource.remove(virtualBackgroundProcessor)
        }
    }

    // MARK: - RoomDelegate

    nonisolated func roomPublicationListDidChange(_ room: Room) {}
    nonisolated func room(_ room: Room, didPublishStreamOf publication: RoomPublication) {}
    nonisolated func room(_ room: Room, didUnsubscribePublicationOf subscription: RoomSubscription) {}
}

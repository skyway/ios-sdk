//
//  ViewController.swift
//  Tutorial
//
//  Created by Naoto Takahashi on 2022/09/16.
//  Copyright © 2025 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import UIKit
import SkyWayRoom

class ViewController: UIViewController {
    @IBOutlet weak var localView: CameraPreviewView!
    @IBOutlet weak var remoteView: VideoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            let token: String = "トークンを入力"
            // SkyWayのセットアップ
            let contextOpt: ContextOptions = .init()
            contextOpt.logLevel = .trace
            try? await Context.setup(withToken: token, options: contextOpt)
            let roomInit: Room.InitOptions = .init()
            guard let room: Room = try? await .create(with: roomInit) else {
                 print("[Tutorial] Creating room failed.")
                 return
            }
            let memberInit: Room.MemberInitOptions = .init()
            memberInit.name = "Alice" // Memberに名前を付けることができます
            guard let member = try? await room.join(with: memberInit) else {
                 print("[Tutorial] Join failed.")
                 return
            }
            // AudioStreamの作成
            let audioSource: MicrophoneAudioSource = .init()
            let audioStream = audioSource.createStream()
            let audioPublicationOptions: RoomPublicationOptions = .init()
            audioPublicationOptions.type = .SFU
            guard let audioPublication = try? await member.publish(audioStream, options: audioPublicationOptions) else {
                 print("[Tutorial] Publishing failed.")
                 return
            }
            // Audioの場合、subscribeした時から音声が流れます
            guard let _ = try? await member.subscribe(publicationId: audioPublication.id, options: nil) else {
                 print("[Tutorial] Subscribing failed.")
                 return
            }
            print("🎉Subscribing audio stream successfully.")

            // Cameraの設定
            guard let camera = CameraVideoSource.supportedCameras().first(where: { $0.position == .front }) else {
                print("Supported cameras is not found.");
                return
            }
            // キャプチャーの開始
            try! await CameraVideoSource.shared().startCapturing(with: camera, options: nil)
            // Previewの描画
            CameraVideoSource.shared().attach(localView)

            // VideoStreamの作成
            let localVideoStream = CameraVideoSource.shared().createStream()
            let videoPublicationOptions: RoomPublicationOptions = .init()
            videoPublicationOptions.type = .SFU
            guard let videoPublication = try? await member.publish(localVideoStream, options: videoPublicationOptions) else {
                 print("[Tutorial] Publishing failed.")
                 return
            }
            guard let videoSubscription = try? await member.subscribe(publicationId: videoPublication.id, options: nil) else {
                 print("[Tutorial] Subscribing failed.")
                 return
            }
            print("🎉Subscribing video stream successfully.")

            let remoteVideoStream = videoSubscription.stream as! RemoteVideoStream
            remoteVideoStream.attach(remoteView)
        }
    }
}


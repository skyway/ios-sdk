//
//  RemoteVideoView.swift
//  Tutorial
//
//  Copyright © 2025 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import SwiftUI
import SkyWayRoom

struct RemoteVideoView: UIViewRepresentable {
    typealias UIViewType = VideoView
    typealias Context = UIViewRepresentableContext<Self>

    let stream: RemoteVideoStream?

    func makeUIView(context: Context) -> VideoView {
        let view = VideoView()
        view.videoContentMode = .scaleAspectFit
        return view
    }

    func updateUIView(_ uiView: VideoView, context: Context) {
        stream?.attach(uiView)
    }

    static func dismantleUIView(_ uiView: VideoView, coordinator: ()) {
        // 何もしない（streamのライフサイクルはRoomViewModelが管理）
    }
}

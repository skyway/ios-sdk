//
//  LocalVideoView.swift
//  Tutorial
//
//  Copyright © 2025 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import SkyWayRoom
import SwiftUI

struct LocalVideoView: UIViewRepresentable {
    typealias UIViewType = VideoView
    typealias Context = UIViewRepresentableContext<Self>

    let stream: LocalVideoStream?

    func makeUIView(context: Context) -> VideoView {
        let view = VideoView()
        view.videoContentMode = .scaleAspectFit
        return view
    }

    func updateUIView(_ uiView: VideoView, context: Context) {
        stream?.attach(uiView)
    }
}

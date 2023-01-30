//
//  RepresentableVideoView.swift
//  P2PRoom
//
//  Created by Naoto Takahashi on 2022/12/26.
//

import SwiftUI
import SkyWayRoom

struct RepresentableVideoView: UIViewRepresentable {
    typealias UIViewType = VideoView
    typealias Context = UIViewRepresentableContext<Self>
    class Cordinator: NSObject {
        let view: RepresentableVideoView
        init(view: RepresentableVideoView) {
            self.view = view
        }
    }
    var stream: VideoStreamProtocol
    func makeUIView(context: Context) -> VideoView {
        let view = VideoView()
        view.videoContentMode = .scaleAspectFit
        return view
    }
    
    func updateUIView(_ uiView: VideoView, context: Context) {
        stream.attach(uiView)
    }
    
    func makeCoordinator() -> Cordinator {
        return Cordinator(view: self)
    }
    
    static func dismantleUIView(_ uiView: VideoView, coordinator: Cordinator) {
        coordinator.view.stream.detach(uiView)
    }
    
}

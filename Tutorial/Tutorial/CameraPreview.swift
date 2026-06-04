//
//  CameraPreview.swift
//  Tutorial
//
//  Copyright © 2025 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import SwiftUI
import SkyWayRoom

struct CameraPreview: UIViewRepresentable {
    typealias UIViewType = CameraPreviewView
    typealias Context = UIViewRepresentableContext<Self>

    func makeUIView(context: Context) -> CameraPreviewView {
        return CameraPreviewView()
    }

    func updateUIView(_ uiView: CameraPreviewView, context: Context) {
        CameraVideoSource.shared().attach(uiView)
    }

    static func dismantleUIView(_ uiView: CameraPreviewView, coordinator: ()) {
        CameraVideoSource.shared().detach(uiView)
    }
}

//
//  ContentView.swift
//  Tutorial
//
//  Copyright © 2025 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RoomViewModel()

    var body: some View {
        VStack(spacing: 0) {
            CameraPreview()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            RemoteVideoView(stream: viewModel.remoteVideoStream)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            Task { await viewModel.start() }
        }
    }
}

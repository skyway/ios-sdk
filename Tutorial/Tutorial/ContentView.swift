//
//  ContentView.swift
//  Tutorial
//
//  Copyright © 2025 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RoomViewModel()
    @State private var roomName: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField("Room name", text: $roomName)
                    .textFieldStyle(.roundedBorder)

                Button("Join") {
                    Task {
                        await viewModel.start(roomName: roomName)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(roomName.isEmpty)
            }

            LocalVideoView(stream: viewModel.localVideoStream)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            RemoteVideoView(stream: viewModel.remoteVideoStream)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}

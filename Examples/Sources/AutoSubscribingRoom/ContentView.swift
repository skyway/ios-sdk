//
//  ContentView.swift
//  AutoSubscribingRoom
//
//  Created by Naoto Takahashi on 2023/01/17.
//  Copyright © 2025 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import SwiftUI
import SkyWayRoom

struct ContentView: View {
    @ObservedObject var skyway: SkyWayViewModel = .init()
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @State var roomNameText: String = ""
    @State var joinButtonTitle: String = "Join"
    @State var isP2PRoom: Bool = true
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: isP2PRoom ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isP2PRoom ? .green : .gray)
                        Text("P2PRoom")
                    }.onTapGesture {
                        if !isP2PRoom && !skyway.isJoined {
                            isP2PRoom = !isP2PRoom
                        }
                    }
                    HStack {
                        Image(systemName: !isP2PRoom ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(!isP2PRoom ? .green : .gray)
                        Text("SFURoom")
                    }.onTapGesture {
                        if isP2PRoom && !skyway.isJoined{
                            isP2PRoom = !isP2PRoom
                        }
                    }
                }
                Section {
                    TextField("Enter Room name", text: $roomNameText)
                    HStack{
                        Spacer()
                        Text(joinButtonTitle)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if skyway.isJoined {
                            Task {
                                joinButtonTitle = "Leaving..."
                                try? await skyway.leave()
                                joinButtonTitle = "Join"
                            }
                        }else {
                            if roomNameText.isEmpty {
                                alertMessage = "Room名を入力してください。"
                                showingAlert = true
                                return
                            }
                            Task {
                                joinButtonTitle = "Joining..."
                                guard let _ = try? await skyway.joinRoom(roomName: roomNameText, roomType: isP2PRoom ? .P2P : .SFU) else {
                                    return
                                }
                                joinButtonTitle = "Leave"
                                try await skyway.publishStreams(includeDataStream: false)
                                for pub in skyway.remotePublications {
                                    guard let _ = try? await skyway.subscribe(publication: pub) else {
                                        return
                                    }
                                }
                            }
                        }
                    }
                } header: {
                    Text("Join Room")
                }
                Section {
                    RepresentableCameraPreviewView()
                        .aspectRatio(9 / 16, contentMode: .fit)
                        .padding()
                } header: {
                    Text("Your video")
                }
                Section {
                    ForEach(skyway.localSubscriptions.filter({ $0.stream is RemoteVideoStream })) { sub in
                        VStack {
                            let videoStream = sub.stream as! RemoteVideoStream
                            RepresentableVideoView(stream: videoStream)
                                .aspectRatio(4 / 3, contentMode: .fit)
                                .background(Color.black)
                                .padding()
                            if !isP2PRoom {
                                Button {
                                    skyway.changePreferredEncoding(subscriptionId: sub.id, encodingId: skyway.highEncodeId)
                                } label: {
                                    Text("High")
                                        .frame(width:200)
                                }.buttonStyle(.bordered)

                                Button {
                                    skyway.changePreferredEncoding(subscriptionId: sub.id, encodingId: skyway.lowEncodeId)
                                } label: {
                                    Text("Low")
                                        .frame(width:200)
                                }.buttonStyle(.bordered)
                            }
                        }
                    }
                } header: {
                    Text("Subscribing video")
                }
            }
            .navigationTitle("SkyWay Example: Auto Subscribing Room")
            .navigationBarTitleDisplayMode(.inline)
        }.onAppear {
            Task {
                do {
                    skyway.isAutoSubscribing = true
                    try await skyway.setup()
                }catch {
                    alertMessage = "Setupに失敗しました。\nAuthTokenが正しく生成されているか確認してください。"
                    showingAlert = true
                }
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text(alertMessage))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

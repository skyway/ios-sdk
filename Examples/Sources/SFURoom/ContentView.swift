//
//  ContentView.swift
//  SFURoom
//
//  Created by Naoto Takahashi on 2023/01/05.
//

import SwiftUI
import SkyWayRoom

struct ContentView: View {
    @ObservedObject var skyway: SkyWayViewModel = .init()
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @State var roomNameText: String = ""
    @State var memberId: String = ""
    @State var joinButtonTitle: String = "Join"
    
    var body: some View {
        NavigationView {
            List {
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
                                if let _memberId = try? await skyway.joinRoom(roomName: roomNameText, roomType: .SFU) {
                                    memberId = _memberId
                                }
                                joinButtonTitle = "Leave"
                                try await skyway.publishStreams(includeDataStream: false)
                            }
                        }
                    }
                } header: {
                    Text("Join Room")
                } footer: {
                    Text("Your Member ID\n\(memberId)")
                }
                Section {
                    RepresentableCameraPreviewView()
                        .aspectRatio(9 / 16, contentMode: .fit)
                        .padding()
                } header: {
                    Text("Publishing your video")
                }.onTapGesture {
                    skyway.toggleVideoEncoding(roomType: .SFU)
                }
                Section {
                    ForEach(skyway.remotePublications) { pub in
                        RemotePublicationView(skyway: skyway, publication: pub)
                    }
                } header: {
                    Text("Subscribe")
                }
                Section {
                    ForEach(skyway.localSubscriptions.filter({ $0.stream is RemoteVideoStream })) { sub in
                        VStack {
                            let videoStream = sub.stream as! RemoteVideoStream
                            RepresentableVideoView(stream: videoStream)
                                .aspectRatio(4 / 3, contentMode: .fit)
                                .background(Color.black)
                                .padding()
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
                } header: {
                    Text("Subscribing video")
                }
            }
            .navigationTitle("SkyWay Example: SFU Room")
            .navigationBarTitleDisplayMode(.inline)
        }.onAppear {
            Task {
                do {
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

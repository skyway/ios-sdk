//
//  ContentView.swift
//  P2PRoom
//
//  Created by Naoto Takahashi on 2022/12/23.
//

import SwiftUI
import SkyWayRoom

struct ContentView: View {
    @ObservedObject var skyway: SkyWayViewModel = .init()
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @State var roomNameText: String = ""
    @State var messageToSend: String = ""
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
                                if let _memberId = try? await skyway.joinRoom(roomName: roomNameText, roomType: .P2P) {
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
                    skyway.toggleVideoEncoding(roomType: .P2P)
                }
                Section {
                    TextField("", text: $messageToSend)
                    HStack{
                        Spacer()
                        Text("Send")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        skyway.sendMessage(messageToSend)
                    }
                } header: {
                    Text("Send message")
                }
                Section {
                    Text(skyway.receivedMessage)
                } header: {
                    Text("Received message")
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
                        let videoStream = sub.stream as! RemoteVideoStream
                        RepresentableVideoView(stream: videoStream)
                            .aspectRatio(4 / 3, contentMode: .fit)
                            .background(Color.black)
                            .padding()
                    }
                } header: {
                    Text("Subscribing video")
                }
            }
            .navigationTitle("SkyWay Example: P2P Room")
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

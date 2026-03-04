//
//  DefaultRoomApp.swift
//  DefaultRoom
//
//  Copyright © 2025 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import SwiftUI

@main
struct DefaultRoomApp: App {
    @State var isSimulator: Bool = false
    var body: some Scene {
        WindowGroup {
            ContentView()
#if targetEnvironment(simulator)
                .onAppear {
                    isSimulator = true
                }.alert(isPresented: $isSimulator){
                    Alert(title: Text("本サンプルはiPhone Simulatorをサポートしていません。実機から起動してください。"))
                }
#endif
        }
    }
}

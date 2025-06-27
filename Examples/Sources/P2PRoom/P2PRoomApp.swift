//
//  P2PRoomApp.swift
//  P2PRoom
//
//  Created by Naoto Takahashi on 2022/12/23.
//  Copyright © 2025 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import SwiftUI

@main
struct P2PRoomApp: App {
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

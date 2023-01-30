//
//  SFURoomApp.swift
//  SFURoom
//
//  Created by Naoto Takahashi on 2023/01/05.
//

import SwiftUI

@main
struct SFURoomApp: App {
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

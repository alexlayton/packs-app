//
//  PacksApp.swift
//  Shared
//
//  Created by Alex Layton on 10/07/2021.
//

import SwiftUI

@main
struct PacksApp: App {
    
    let appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

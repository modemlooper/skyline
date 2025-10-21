//
//  SkylineApp.swift
//  Skyline
//
//  Created by modemlooper on 10/21/25.
//

import SwiftUI

@main
struct SkylineApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Window("Skyline", id: "main-window") {
            MainWindowView()
        }
        .defaultSize(width: 900, height: 600)
    }
}

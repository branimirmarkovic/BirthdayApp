//
//  BirthdayAppApp.swift
//  BirthdayApp
//
//  Created by Branimir Markovic on 1.2.22..
//

import SwiftUI

@main
struct BirthdayAppApp: App {
    var body: some Scene {
        CompositionRoot.fileManager()
        return WindowGroup {
            ContentView()
        }
    }
}

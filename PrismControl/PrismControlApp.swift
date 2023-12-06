//
//  PrismControlApp.swift
//  PrismControl
//
//  Created by Kai Peintinger on 18.11.23.
//

import SwiftUI

@main
struct PrismControlApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ColorViewModel.shared)
        }
    }
}

//
//  ContentView.swift
//  PrismControl
//
//  Created by Kai Peintinger on 18.11.23.
//
import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 0
    @State private var showNotificationDot = true
    @State private var isAppLoaded = false
    
    var body: some View {
        if isAppLoaded {
            TabView(selection: $selectedTab) {
                HomeUI()
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag(0)
                SceneUI()
                    .tabItem { Label("Scene", systemImage: "paintbrush.pointed")}
                    .tag(1)
                MeUI()
                    .tabItem { Label("Me", systemImage: "person.crop.circle") }
                    .tag(3)
            }
        } else {
            LoadingUI(onWelcomeCompletion: {
                isAppLoaded = true
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

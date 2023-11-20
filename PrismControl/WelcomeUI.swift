//
//  WelcomeUI.swift
//  PrismControl
//
//  Created by Kai Peintinger on 20.11.23.
//

import Foundation
import SwiftUI

struct WelcomeUI: View {
    @State private var opacity: Double = 1.0
    var onWelcomeCompletion: () -> Void

    var body: some View {
        VStack {
            Text("PrismControl")
                .font(.largeTitle)
                .padding()
                .opacity(opacity)
                .animation(.easeOut(duration: 1.0), value: opacity)
            
            Image(systemName: "move.3d")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75, height: 75)
                .opacity(opacity)
                .animation(.easeOut(duration: 1.0), value: opacity)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    opacity = 0.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    onWelcomeCompletion()
                }
            }
        }
    }
}

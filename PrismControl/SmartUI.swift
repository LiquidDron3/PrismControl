//
//  SmartUI.swift
//  PrismControl
//
//  Created by Kai Peintinger on 20.11.23.
//

import Foundation
import SwiftUI

struct SmartUI: View {
    var body: some View {
        VStack {
            Image(systemName: "keyboard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            HStack {
                Text("Developer typing code...")
                    .font(.title)
                    .foregroundColor(.white)
                
                Cursor()
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
    }
}

struct Cursor: View {
    @State private var showCursor = true

    var body: some View {
        Text("|")
            .opacity(showCursor ? 1 : 0)
            .onAppear {
                blinkCursor()
            }
    }

    private func blinkCursor() {
        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever()) {
            showCursor.toggle()
        }
    }
}

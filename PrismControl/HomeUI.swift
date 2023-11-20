//
//  HomeUI.swift
//  PrismControl
//
//  Created by Kai Peintinger on 20.11.23.
//

import Foundation
import SwiftUI

struct HomeUI: View {
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

//
//  SceneUI.swift
//  PrismControl
//
//  Created by Kai Peintinger on 20.11.23.
//

import Foundation
import SwiftUI

struct SceneUI: View {
    
    @State private var redValue: Double = 128
    @State private var greenValue: Double = 0
    @State private var blueValue: Double = 128
    
    var hexColor: String {
            let redInt = Int(redValue)
            let greenInt = Int(greenValue)
            let blueInt = Int(blueValue)
            
            return String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
        }
    
    var body: some View {
        VStack {
            Text("RED")
                .frame(width: 75, height: 50)
            
            HStack {
                TextField("", value: $redValue, formatter: NumberFormatter())
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 125, height: 50)
                    .multilineTextAlignment(.center)
                
                Slider(value: $redValue, in: 0...255, step: 1)
                Spacer()
            }
            
            Text("GREEN")
                .frame(width: 75, height: 50)
            
            HStack {
                TextField("", value: $greenValue, formatter: NumberFormatter())
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 125, height: 50)
                    .multilineTextAlignment(.center)
                
                Slider(value: $greenValue, in: 0...255, step: 1)
                Spacer()
            }
            Text("BLUE")
                .frame(width: 75, height: 50)
            HStack {
                TextField("", value: $blueValue, formatter: NumberFormatter())
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 125, height: 50)
                    .multilineTextAlignment(.center)
                
                Slider(value: $blueValue, in: 0...255, step: 1)
                Spacer()
            }
            HStack {
                Text("Hex Value: \(hexColor)")
                    .padding()
                    .foregroundColor(.black)
                    .background(Color(UIColor(hex: hexColor)))
                    .cornerRadius(10)
                    .frame(width: 400, height: 50)
            }
            .padding()
            HStack {
                Button("Load Data") {
                }
                .padding()
                            
                Button("Send Data") {
                }
                .padding()
            }
            .padding()
        }
        

    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}



struct SceneUI_Previews: PreviewProvider {
    static var previews: some View {
        SceneUI()
    }
}

//
//  SceneUI.swift
//  PrismControl
//
//  Created by Kai Peintinger on 20.11.23.
//

import Foundation
import SwiftUI
import Combine


enum LEDEffect: String, CaseIterable, Identifiable {
    case staticColor = "Static"
    case breath = "Breath"
    case flash = "Flash"
    case runningLight = "Running"
    case rainbow = "Rainbow"

    var id: String { self.rawValue }
}

class ColorViewModel: ObservableObject {
    @Published var redValue: Double = 0 {
        didSet {
            updateBleInformation()
        }
    }
    @Published var greenValue: Double = 255 {
        didSet {
            updateBleInformation()
        }
    }
    @Published var blueValue: Double = 0 {
        didSet {
            updateBleInformation()
        }
    }
    @Published var speed: Double = 1.0 {
        didSet {
            updateBleInformation()
        }
    }
    @Published var selectedEffect: LEDEffect = .staticColor {
        didSet {
            updateBleInformation()
        }
    }

    var hexColor: String {
        let redInt = Int(redValue)
        let greenInt = Int(greenValue)
        let blueInt = Int(blueValue)

        return String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
    }

    var bleInformation: String {
        SharedData.shared.bleInformation
    }

    func updateBleInformation() {
        SharedData.shared.bleInformation = String(format: "%@:%@:%.1f", hexColor, selectedEffect.rawValue, speed)
    }
    static var shared: ColorViewModel = ColorViewModel()
}

struct SceneUI: View {
    @StateObject private var colorViewModel = ColorViewModel.shared
    
    var effectPreview: LEDEffectPreview {
            LEDEffectPreview(viewModel: colorViewModel)
        }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    effectPreview
                        .padding()
                }
                VStack {
                    Text("Speed")
                    Slider(value: $colorViewModel.speed, in: 0.1...1.9, step: 0.1)
                        .padding()
                        .frame(width: 350)
                }
                List {
                    NavigationLink(destination: ChooseColor(viewModel: colorViewModel)) {
                        HStack {
                            Text("Color")
                            Spacer()
                            Text(colorViewModel.hexColor)
                                .foregroundColor(Color(UIColor(hex: colorViewModel.hexColor)))
                        }
                        .padding()
                    }
                    NavigationLink(destination: ChooseEffect(viewModel: colorViewModel)) {
                        HStack {
                            Text("Effect")
                            Spacer()
                            Text(colorViewModel.selectedEffect.rawValue)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
            }
            .onAppear() {
                colorViewModel.updateBleInformation()
            }
            .navigationTitle("LED Settings")
        }
    }
}

struct LEDEffectPreview: View {
    @ObservedObject var viewModel: ColorViewModel
    @State private var brightness: Double = 1.0
    @State private var runningLightIndex: Int = 0
    @State private var hue: Double = 0.0
    
    var body: some View {
        
        let hexColor = viewModel.hexColor
        VStack {
            HStack(spacing: 16) {
                switch viewModel.selectedEffect {
                case .staticColor:
                    ForEach(0..<7) { index in
                        Circle()
                            .fill(Color(UIColor(hex: hexColor)))
                            .frame(width: 30, height: 30)
                    }
                    
                case .breath:
                    ForEach(0..<7) { index in
                        Circle()
                            .fill(Color(UIColor(hex: hexColor)))
                            .brightness(brightness)
                            .frame(width: 30, height: 30)
                            .onAppear {
                                startBreathingEffect()
                            }
                    }
                    
                case .flash:
                    ForEach(0..<7) { index in
                        Circle()
                            .fill(Color(UIColor(hex: hexColor)))
                            .brightness(brightness)
                            .frame(width: 30, height: 30)
                            .onAppear {
                                startFlashEffect()
                            }
                    }
                    
                case .runningLight:
                    ForEach(0..<7) { index in
                        Circle()
                            .fill(Color(UIColor(hex: hexColor)))
                            .opacity(index == runningLightIndex ? 1.0 : 0.3)
                            .frame(width: 30, height: 30)
                    }
                    .onAppear {
                        startRunningLightEffect()
                    }
                case .rainbow:
                    ForEach(0..<7) { index in
                        Circle()
                            .fill(
                                Color(hue: hue.truncatingRemainder(dividingBy: 1.0),
                                      saturation: 1,
                                      brightness: 1)
                            )
                            .frame(width: 30, height: 30)
                    }
                    .onAppear {
                        startRainbowEffect()
                    }
                }
            }
        }
    }
    
    func startRainbowEffect() {
        let interval: TimeInterval = 0.02

        func updateHue() {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval / self.viewModel.speed) {
                withAnimation {
                    hue += 0.005
                    if hue > 1.0 {
                        hue = 0.0
                    }
                }
                if self.viewModel.selectedEffect == .rainbow {
                    updateHue()
                }
            }
        }
        updateHue()
    }
    
    func startRunningLightEffect() {
        let interval: TimeInterval = 0.5

        func runLight() {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval / self.viewModel.speed) {
                withAnimation {
                    runningLightIndex = (runningLightIndex + 1) % 7
                }
                if self.viewModel.selectedEffect == .runningLight {
                    runLight()
                }
            }
        }
        runLight()
    }
    
    func startBreathingEffect() {
        let interval: TimeInterval = 0.4
        
        func breathe() {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval / self.viewModel.speed) {
                withAnimation {
                    self.brightness = 0.2 + 0.6 * abs(sin(Date().timeIntervalSinceReferenceDate))
                }
                if self.viewModel.selectedEffect == .breath {
                    breathe()
                }
            }
        }
        breathe()
    }

    func startFlashEffect() {
        let flashInterval: TimeInterval = 0.5
        
        func flash() {
            DispatchQueue.main.asyncAfter(deadline: .now() + flashInterval / self.viewModel.speed) {
                withAnimation {
                    self.brightness = (self.brightness == 0.0) ? 1.0 : 0.0
                }
                if self.viewModel.selectedEffect == .flash {
                    flash()
                }
            }
        }
        flash()
    }
}


struct ChooseColor: View {
    @ObservedObject var viewModel: ColorViewModel

    var body: some View {
        VStack {
            Text("RED")
                .frame(width: 75, height: 50)
            HStack {
                TextField("", value: $viewModel.redValue, formatter: NumberFormatter())
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 125, height: 50)
                    .multilineTextAlignment(.center)

                Slider(value: $viewModel.redValue, in: 0...255, step: 1)
                Spacer()
            }
            Text("GREEN")
                .frame(width: 75, height: 50)

            HStack {
                TextField("", value: $viewModel.greenValue, formatter: NumberFormatter())
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 125, height: 50)
                    .multilineTextAlignment(.center)

                Slider(value: $viewModel.greenValue, in: 0...255, step: 1)
                Spacer()
            }
            Text("BLUE")
                .frame(width: 75, height: 50)

            HStack {
                TextField("", value: $viewModel.blueValue, formatter: NumberFormatter())
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 125, height: 50)
                    .multilineTextAlignment(.center)

                Slider(value: $viewModel.blueValue, in: 0...255, step: 1)
                Spacer()
            }
            HStack {
                Circle()
                    .fill(Color(UIColor(hex: viewModel.hexColor)))

                    .frame(width: 30, height: 30)

            }
            .padding()
            .navigationTitle("Color Picker")
        }
    }
}

struct ChooseEffect: View {
    @ObservedObject var viewModel: ColorViewModel

    var body: some View {
        VStack {
            Picker("LED Effect", selection: $viewModel.selectedEffect) {
                ForEach(LEDEffect.allCases) { effect in
                    Text(effect.rawValue)
                        .tag(effect)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()
        }
        .navigationTitle("Effect Picker")
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

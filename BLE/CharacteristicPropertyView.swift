//
//  CharacteristicPropertyView.swift
//  PrismControl
//
//  Created by Kai Peintinger on 25.11.23.
//

import Foundation
import SwiftUI
import Foundation
import CoreBluetooth

struct CharacteristicPropertyView: View {
    @ObservedObject public var oneChar: UserBleCharacteristic
    @StateObject public var oneDevPeri: UserBlePeripheral
    @StateObject var bleObj: BleCommViewModel
    @EnvironmentObject var colorViewModel: ColorViewModel
    @State private var sentData: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            if isCharsWriteable() {
                HStack(alignment: .center) {
                    Spacer().frame(width: 10)
                    Button(action: {
                        if let data = colorViewModel.bleInformation.data(using: .utf8) {
                            if(!data.isEmpty) {
                                sentData = String(data: data, encoding: .utf8) ?? "Convert Data to String failed"
                                oneDevPeri.userPeripheral.writeValue(data, for: oneChar.characteristic, type: .withResponse)
                            }
                            else {
                                sentData = String("Select Data please!")
                            }
                        }
                    }) {
                        Text("Send value")
                            .padding()
                            .frame(width: 175.0, height: 40.0)
                            .foregroundColor(Color.white)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
                Text(sentData)
                    .padding()
            }
        }
    }
    func isCharsWriteable() -> Bool {
        if (oneChar.characteristic.properties.rawValue & CBCharacteristicProperties.write.rawValue) == 0 {
            return false
        } else {
            return true
        }
    }
}


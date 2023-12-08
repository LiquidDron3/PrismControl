//
//  CharacteristicPropertyView.swift
//  PrismControl
//
//  Created by Kai Peintinger on 25.11.23.
//

import SwiftUI
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
                        if (!colorViewModel.bleInformation.isEmpty) {
                            let information = colorViewModel.bleInformation
                            for value in information {
                                let dataToSend = Data([value])
                                oneDevPeri.userPeripheral.writeValue(dataToSend, for: oneChar.characteristic, type: .withResponse)
                            }
                            sentData = "Data was sent"
                        } else {
                            sentData = "Select Data please!"
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
        (oneChar.characteristic.properties.rawValue & CBCharacteristicProperties.write.rawValue) != 0
    }
}

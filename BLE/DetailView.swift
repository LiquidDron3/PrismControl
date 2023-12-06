//
//  DetailView.swift
//  PrismControl
//
//  Created by Kai Peintinger on 06.12.23.
//

import Foundation
import SwiftUI
import CoreBluetooth

struct DetailView: View {
    
    @StateObject public var oneDev: UserBlePeripheral
    @StateObject public var bleViewModel: BleCommViewModel
    @State var connectionStatus: String = "Connecting ..."
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Selected Device: \(oneDev.name)" )
            if oneDev.userPeripheral.state == CBPeripheralState.connected {
                Text("Connected")
                ForEach(bleViewModel.connectedUserBlePeripheral?.userServices ?? []) { service in
                    ForEach(service.userCharacteristices) { userChar in
                        CharacteristicPropertyView(
                            oneChar: userChar,
                            oneDevPeri: bleViewModel.connectedUserBlePeripheral!,
                            bleObj: bleViewModel)
                    }
                }
            } else {
                Text("\(connectionStatus)")
                var count = 0
                let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if count >= 3 {
                        connectionStatus = "Cannot connect"
                        timer.invalidate()
                    }
                    count += 1
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: goBack) {
                    Text("Back")
                        .padding()
                        .frame(width: 100.0, height: 40.0)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
        )
        .onAppear {
            bleViewModel.centralManager?.connect(oneDev.userPeripheral)
        }
    }
    func goBack() {
        self.presentationMode.wrappedValue.dismiss()
        bleViewModel.centralManager?.cancelPeripheralConnection(oneDev.userPeripheral)
    }
}

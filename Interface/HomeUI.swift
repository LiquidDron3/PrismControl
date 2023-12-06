//
//  HomeUI.swift
//  PrismControl
//
//  Created by Kai Peintinger on 20.11.23.
//

import Foundation
import SwiftUI

struct HomeUI: View {
    @ObservedObject private var bluetoothViewModel = BleCommViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(bluetoothViewModel.foundPeripherals) { ele in
                    NavigationLink(destination: DetailView(oneDev: ele, bleViewModel: bluetoothViewModel)) {
                        PeripheralCell(onePeri: ele)
                    }
                }
            }
            .navigationBarTitle("Bluethooth devices")
        }
    }
}

struct PeripheralCell: View {
    @ObservedObject var onePeri: UserBlePeripheral
    var body: some View {
        
        LabeledContent {
            Text("\(onePeri.rssi) dBm")
          
        } label: {
            Text(onePeri.name)
        }
    }
}

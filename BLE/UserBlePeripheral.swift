//
//  UserBlePeripheral.swift
//  PrismControl
//
//  Created by Kai Peintinger on 25.11.23.
//

import Foundation
import CoreBluetooth

class UserBlePeripheral: Identifiable, ObservableObject {
    
    @Published var id: UUID
    @Published var userPeripheral: CBPeripheral
    @Published var userServices: [UserBleService]
    @Published var name: String
    @Published var rssi: Int
    
    init(_userPeripheral: CBPeripheral,
         _userServices: [UserBleService],
         _name: String,
         _rssi: Int
         )
    {
        id = UUID()
        userServices = _userServices
        userPeripheral = _userPeripheral
        name = _name
        rssi = _rssi
    }
}

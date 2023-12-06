//
//  BleCommViewModel.swift
//  PrismControl
//
//  Created by Kai Peintinger on 25.11.23.
//

import Foundation
import SwiftUI
import CoreBluetooth

class BleCommViewModel: NSObject, ObservableObject {
    
    @Published var centralManager: CBCentralManager?
    @Published var foundOnePeripheral: UserBlePeripheral!
    @Published var foundPeripherals: [UserBlePeripheral] = []
    @Published var connectedUserBlePeripheral: UserBlePeripheral?
    @Published var foundServiceName : String = " "       // to quick update Service info on DetailView
    @Published var oneCharsName: String = "..."          // to quick update chars name on DetailView
    @Published var characteristicNameStr: String = "no-name"
    @Published var recValueData: Data?
        
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    var NO_CHARS_NAME = "NO_CHARS_NAME"
}

extension BleCommViewModel: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(central.state == .poweredOn) {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
        
        switch central.state {
                
            case .poweredOff:
                print("Power is Off")
                
            case .poweredOn:
                print("Power is On, scanning Ble devices")
                self.centralManager?.scanForPeripherals(withServices: nil)
                
            case .unsupported:
                print("Unsupport")
                
            case .unauthorized:
                print("Unauthorized")
                
            case .unknown:
                print("Unknown")
                
            case .resetting:
                print("Resetting")
                
            @unknown default:
                print("Error")
                
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let peripheralName = peripheral.name, !peripheralName.isEmpty else {
            return
        }

        foundOnePeripheral = UserBlePeripheral(
            _userPeripheral: peripheral,
            _userServices: [],
            _name: peripheralName,
            _rssi: RSSI.intValue
        )

        if !IsInFoundPeripherals(foundOnePeripheral) {
            foundPeripherals.append(foundOnePeripheral)
        }
    }
    
    func IsInFoundPeripherals (_ onePeripheral: UserBlePeripheral) -> Bool {
        for item in foundPeripherals {
            if item.userPeripheral.identifier.uuidString == onePeripheral.userPeripheral.identifier.uuidString {
                return true
            }
        }
        return false
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected device")
        resetConfigure()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("One device conected")
        peripheral.delegate = self;
        
        connectedUserBlePeripheral = UserBlePeripheral(
            _userPeripheral: peripheral,
            _userServices: [],
            _name: peripheral.name ?? "not provided name",
            _rssi: foundOnePeripheral.rssi
        )
        
        peripheral.discoverServices(nil)
        print("Getting services")
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?.forEach { oneService in
            
            let serName = getServiceName(serviceDescription: oneService.description)
            print("Service info:\n \(oneService.description)")
            print("\nService name: \(serName)")
            
            foundServiceName = serName
            
            let foundOneService: UserBleService = UserBleService (
                                                    _uuid: oneService.uuid,
                                                    _service: oneService,
                                                    _serviceName: serName,
                                                    _userCharacteristices: []
                                                    )
            
            let oneUserBleService: UserBleService = UserBleService (
                _uuid: foundOneService.uuid,
                _service: foundOneService.service,
                _serviceName: serName,
                _userCharacteristices: []
            )
            connectedUserBlePeripheral?.userServices.append(oneUserBleService)
            
            print("Found one service: \(foundOneService.uuid.uuidString)")
            peripheral.discoverCharacteristics(nil, for: foundOneService.service)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    
        // set descriptor on each characteristic
        service.characteristics?.forEach { characteristic in
            
            // get descriptor in each characteristic
            peripheral.discoverDescriptors(for: characteristic)
            
            // setup for user
            let foundOneUserChar : UserBleCharacteristic = UserBleCharacteristic(
                _characteristic: characteristic,
                _uuid: characteristic.uuid,
                _characteristicName: characteristicNameStr
                )
                        
            // add this found-characteristic to the service
            // check to make sure it matches with this service
            for item in connectedUserBlePeripheral?.userServices ?? [] {
                
                if item.uuid.uuidString == service.uuid.uuidString {
                    
                    print("Found one characteristic: \(foundOneUserChar.uuid.uuidString)")
                    item.userCharacteristices.append(foundOneUserChar)
                }
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        guard let descriptors = characteristic.descriptors else {
            print("Cannot find descriptor")
            return
        }
        
        // At this point, we found the description of the characteristic
        print("Found the descriptor: \(descriptors)")
        
        // Get characteristic name
        if let userDescriptionDescriptor = descriptors.first(where: {
            return $0.uuid.uuidString == CBUUIDCharacteristicUserDescriptionString
        }) {
            
            // add descriptor to the matched-characteristic
            for oneUserService in connectedUserBlePeripheral?.userServices ?? [] {
                for oneUserChar in oneUserService.userCharacteristices {
                    
                    // check for match
                    if oneUserChar.uuid.uuidString == characteristic.uuid.uuidString {
                        
                        oneUserChar.characteristicName = userDescriptionDescriptor.value as? String ?? " "
                        print("FOUND A NAME \(oneUserChar.characteristicName)")
                        
                        oneCharsName = oneUserChar.characteristicName  // to quick update chars name on DetailView
                    }
                }
            }
        }
        else {
            
            // add descriptor to the matched-characteristic
            for oneUserService in connectedUserBlePeripheral?.userServices ?? [] {
                for oneUserChar in oneUserService.userCharacteristices {
                    
                    let charsName = getPredefineCharacteristicName(charsUuidStr: oneUserChar.uuid.uuidString)
                    if( charsName != NO_CHARS_NAME) {
                        oneUserChar.characteristicName  = charsName
                        print("FOUND PREDEFINED NAME \(oneUserChar.characteristicName)")
                    }
                }
            }
        }
                            
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let recData = characteristic.value else {
            // no data transmitted, handle if needed
            print("no receiving data")
            return
        }
        
        // extract receiving data
        for oneUserService in connectedUserBlePeripheral?.userServices ?? [] {
            
            for oneUserChar in oneUserService.userCharacteristices {
                
                // check for match
                if oneUserChar.uuid.uuidString == characteristic.uuid.uuidString {
                    
                    recValueData = recData
                    
                    // convert Data to array
                    let bytes = [UInt8](recValueData ?? Data())
                    
                    let valStr = bytes.map { String(format: "%02X", $0) }.joined(separator: " ")
                    print("receiving: \(valStr)")

                }
            }
        }
                
    }

    func getPredefineCharacteristicName(charsUuidStr: String) -> String {
        
        // set some predefined characteristic names
        // see more in https://www.bluetooth.com/specifications/assigned-numbers/
        let predefineCharsName = [
            "2A29": "Manufacturer Name String",
            "2A24": "Model Number String",
            "2A25": "Serial Number String",
            "2A26": "Firmware Revision String",
            "2A27": "Hardware Revision String",
            "2A39": "Heart Rate Control Point",
            "2A8D": "Heart Rate Max",
            "2A37": "Heart Rate Measurement",
            "2A38": "Body Sensor Location"
        ]
        
        let charsName = findCharsName(for: charsUuidStr, in: predefineCharsName)
        
        return charsName
    }
    
    func findCharsName(for contact: String, in dictionary: [String: String]) -> String {
        guard let charsName = dictionary[contact] else {
            return NO_CHARS_NAME
        }
        return charsName
    }
    
    func getServiceName(serviceDescription: String) -> String {
        
        let target = "UUID = "
        if let range = serviceDescription.range(of: target) {
            let uuidRange = range.upperBound..<serviceDescription.endIndex
            var serviceName = String(serviceDescription[uuidRange])
            
            if serviceName.hasSuffix(">") {
                serviceName.removeLast()
            }
            return serviceName;
        }
        else {
            
            return " "
        }
        
    }

    func resetConfigure() {
        withAnimation {
            connectedUserBlePeripheral = nil
        }
    }
    
}


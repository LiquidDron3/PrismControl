//
//  SharedData.swift
//  PrismControl
//
//  Created by Kai Peintinger on 06.12.23.
//

import SwiftUI

class SharedData: ObservableObject {
    @Published var bleInformation: [UInt8] = []

    static let shared = SharedData()

    private init() {}
}

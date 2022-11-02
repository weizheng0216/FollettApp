//
//  DipSwitchStatus.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 11/1/22.
//

import Foundation

class DipSwitchStatus: ObservableObject {
    
    static let dswitch = DipSwitchStatus()
    
    @Published var isOn: [Bool] = [false, false, false, false, false, false, false, false]
}

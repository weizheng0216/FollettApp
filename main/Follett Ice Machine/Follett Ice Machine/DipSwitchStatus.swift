//
//  DipSwitchStatus.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 11/1/22.
//  Used for displaying the ice machine dipswitches status

import Foundation

class DipSwitchStatus: ObservableObject {
    
    static let dswitch = DipSwitchStatus()
    
    // true indicating dipSwitch on, and vice versa
    @Published var isOn: [Bool] = [true, true, true, true, true, true, true, true]
}

//
//  iceMachineStatus.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/2/22.
//  Used for displaying the ice machine LED status

import Foundation

class IceMachineStatus: ObservableObject {
    
    static let shared = IceMachineStatus()
    
    // array indicating the status for each LED light, 0 for off, 1 for on
    @Published var statusArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
}

//
//  iceMachineStatus.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/2/22.
//

import Foundation

class IceMachineStatus: ObservableObject {
    
    static let shared = IceMachineStatus()
    
    @Published var statusArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
}

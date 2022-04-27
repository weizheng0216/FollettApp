//
//  Follett_Ice_MachineApp.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/22/22.
//

import Foundation
import Charts

public class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "MM.dd."
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

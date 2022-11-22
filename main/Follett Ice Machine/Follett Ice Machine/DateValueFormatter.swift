//
//  DataValueFomatter.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/22/22.
//  Used to convert double value into MM.dd. HH:mm:ss format

import Foundation
import Charts

public class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "MM.dd. HH:mm:ss"
    }
    
    // function for casting double to format date string
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

//
//  ChartsLineChart.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/29/22.
//

import SwiftUI
import Charts

struct AmpChartView: View {
    @ObservedObject var BTManager: BLEManager
    @Binding var data: [ChartDataEntry]
//    = [
//        ChartDataEntry(x: 1650504066, y: 312, data: "My data"),
//        ChartDataEntry(x: 1650590466, y: 189, data: "My data"),
//        ChartDataEntry(x: 1650676866, y: 129, data: "My data"),
//        ChartDataEntry(x: 1650763266, y: 129, data: "My data"),
//        ChartDataEntry(x: 1650849666, y: 289, data: "My data"),
//        ChartDataEntry(x: 1650936066, y: 99, data: "My data"),
//        ChartDataEntry(x: 1651022466, y: 67, data: "My data")
//    ]

    var body: some View {
        
        
        VStack(alignment: .center, spacing: 20) {
            
            LineChart(rawData: BTManager.ampData).frame(width: 300, height: 300, alignment: .center)
//
        }
    }
}

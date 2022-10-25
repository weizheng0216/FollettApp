//
//  ChartsMultipleLineChart.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/29/22.
//

import SwiftUI
import Charts


struct StateChartView: View {
//
//    @State private var data2: [BarChartDataEntry] = [
//        BarChartDataEntry(x: 1, y: 10, data: "My data"),
//        BarChartDataEntry(x: 2, y: 12, data: "My data"),
//        BarChartDataEntry(x: 3, y: 3, data: "My data"),
//        BarChartDataEntry(x: 4, y: 9, data: "My data"),
//        BarChartDataEntry(x: 5, y: 6, data: "My data"),
//        BarChartDataEntry(x: 6, y: 9, data: "My data"),
//        BarChartDataEntry(x: 7, y: 15, data: "My data")
//    ]
    
    @ObservedObject var BTManager: BLEManager
//    @Binding var entries: [ChartDataEntry]

    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            LineChart(entries: BTManager.modeEntries).frame(width: 300, height: 300, alignment: .center)
        }
    }
}


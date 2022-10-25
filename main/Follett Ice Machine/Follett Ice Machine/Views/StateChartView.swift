//
//  ChartsMultipleLineChart.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/29/22.
//

import SwiftUI
import Charts


struct StateChartView: View {
    @State private var data1: [BarChartDataEntry] = [
        BarChartDataEntry(x: 1, yValues: [1,10]),
        BarChartDataEntry(x: 2, yValues: [5,12]),
        BarChartDataEntry(x: 3, yValues: [7,3]),
        BarChartDataEntry(x: 4, yValues: [4,9]),
        BarChartDataEntry(x: 5, yValues: [2,6]),
        BarChartDataEntry(x: 6, yValues: [4,9]),
        BarChartDataEntry(x: 7, yValues: [9,15])
    ]
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

    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
//            Form {
            BarChart(entries: data1 ).frame(height: 300)
//                Button("Add data") {
//                    let max = data.map(\.x).max() ?? 1628071200
//                    data.append(ChartDataEntry(x: max + 86400, y: Double.random(in: 1 ..< 500)))
//                }
//            }
        }
    }
}


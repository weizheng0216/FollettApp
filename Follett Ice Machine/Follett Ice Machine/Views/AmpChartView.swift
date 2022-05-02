//
//  ChartsLineChart.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/29/22.
//

import SwiftUI
import Charts

struct AmpChartView: View {
    @State private var data: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: 312, data: "My data"),
        ChartDataEntry(x: 1650590466, y: 189, data: "My data"),
        ChartDataEntry(x: 1650676866, y: 129, data: "My data"),
        ChartDataEntry(x: 1650763266, y: 129, data: "My data"),
        ChartDataEntry(x: 1650849666, y: 289, data: "My data"),
        ChartDataEntry(x: 1650936066, y: 99, data: "My data"),
        ChartDataEntry(x: 1651022466, y: 67, data: "My data")
    ]

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
//            Form {
            LineChart(entries: data).frame(width: 300, height: 300, alignment: .center)
//                Button("Add data") {
//                    let max = data.map(\.x).max() ?? 1628071200
//                    data.append(ChartDataEntry(x: max + 86400, y: Double.random(in: 1 ..< 500)))
//                }
//            }
        }
    }
}

struct ChartsLineChart_Previews: PreviewProvider {
    static var previews: some View {
        AmpChartView()
    }
}

//
//  UtilizationChartView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/2/22.
//  Intented to be used for the utilization pie chart, not used in the current app

import Charts
import SwiftUI

struct UtilizationChartView: View {
    @State private var data: [PieChartDataEntry] = [
        PieChartDataEntry(value: 354, label: "Offline"),
        PieChartDataEntry(value: 261, label: "Making Ice"),
        PieChartDataEntry(value: 117, label: "Sleep"),
        PieChartDataEntry(value: 37, label: "Time Delay"),
        PieChartDataEntry(value: 37, label: "Shuttle Flush")
    ]

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            PieChart(entries: data).frame(height:300, alignment: .center)
        }
//        Spacer()
    }
}

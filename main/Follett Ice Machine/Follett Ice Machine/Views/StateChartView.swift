//
//  ChartsMultipleLineChart.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/29/22.
//  State/model chart utilizing linechart

import SwiftUI
import Charts


struct StateChartView: View {
    @ObservedObject var BTManager: BLEManager

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            LineChart(entries: BTManager.modeEntries).frame(width: 300, height: 300, alignment: .center)
        }
    }
}


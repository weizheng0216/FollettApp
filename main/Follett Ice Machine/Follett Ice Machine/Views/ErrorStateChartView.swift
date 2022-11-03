//
//  ErrorStateView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 11/01/22.
//

import SwiftUI
import Charts


struct ErrorStateChartView: View {
    @ObservedObject var BTManager: BLEManager
//    @Binding var entries: [ChartDataEntry]

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            StackedBarChart(yVals: BTManager.errorEntries).frame(width: 300, height: 300, alignment: .center)
        }
    }
}


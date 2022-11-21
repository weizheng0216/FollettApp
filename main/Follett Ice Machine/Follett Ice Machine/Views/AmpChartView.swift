//
//  ChartsLineChart.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/29/22.
//  Amp chart utilizing the multiple line chart

import SwiftUI
import Charts

struct AmpChartView: View {
    @ObservedObject var BTManager: BLEManager
    
    var body: some View {

        VStack(alignment: .center, spacing: 20) {
            MultipleLineChart(lowAmps: BTManager.minEntries, highAmps: BTManager.maxEntries).frame(width: 300, height: 300, alignment: .center)
        }
    }
}

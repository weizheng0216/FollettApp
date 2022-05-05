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
    @Binding var entries: [ChartDataEntry]
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            LineChart(entries: BTManager.entries).frame(width: 300, height: 300, alignment: .center)
        }
    }
}

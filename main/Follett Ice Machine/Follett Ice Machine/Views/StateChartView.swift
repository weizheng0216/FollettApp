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
    var currentMode = ""

    var body: some View {
        
        VStack(alignment: .center) {
            Text("0:Standby 1:Water Fill 2:Making ice 3:Time Delay 4:Sleep 5:Shutdown ice making 6:Time delay flush 7:Running flush 8:Clean 9:Maintenance")
                .frame(width: 300, height: 100)
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
            
            LineChart(entries: BTManager.modeEntries).frame(width: 300, height: 300, alignment: .center)
        }
    }
}


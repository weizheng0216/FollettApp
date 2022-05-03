//
//  ChartsMultipleLineChart.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/29/22.
//

import SwiftUI
import Charts


struct StateChartView: View {
    @State private var data1: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: 1, data: "My data"),
        ChartDataEntry(x: 1650590466, y: 1, data: "My data"),
        ChartDataEntry(x: 1650676866, y: -10, data: "My data"),
        ChartDataEntry(x: 1650763266, y: 1, data: "My data"),
        ChartDataEntry(x: 1650849666, y: -10, data: "My data"),
        ChartDataEntry(x: 1650936066, y: 1, data: "My data"),
        ChartDataEntry(x: 1651022466, y: 1, data: "My data")
    ]
    
    @State private var data2: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: 2, data: "My data"),
        ChartDataEntry(x: 1650590466, y: -10, data: "My data"),
        ChartDataEntry(x: 1650676866, y: -10, data: "My data"),
        ChartDataEntry(x: 1650763266, y: -10, data: "My data"),
        ChartDataEntry(x: 1650849666, y: 2, data: "My data"),
        ChartDataEntry(x: 1650936066, y: 2, data: "My data"),
        ChartDataEntry(x: 1651022466, y: -10, data: "My data")
    ]
    
    @State private var data3: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: -10, data: "My data"),
        ChartDataEntry(x: 1650590466, y: -10, data: "My data"),
        ChartDataEntry(x: 1650676866, y: 3, data: "My data"),
        ChartDataEntry(x: 1650763266, y: 3, data: "My data"),
        ChartDataEntry(x: 1650849666, y: -10, data: "My data"),
        ChartDataEntry(x: 1650936066, y: 3, data: "My data"),
        ChartDataEntry(x: 1651022466, y: 3, data: "My data")
    ]
    
    @State private var data4: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: 4, data: "My data"),
        ChartDataEntry(x: 1650590466, y: 4, data: "My data"),
        ChartDataEntry(x: 1650676866, y: 4, data: "My data"),
        ChartDataEntry(x: 1650763266, y: 4, data: "My data"),
        ChartDataEntry(x: 1650849666, y: -10, data: "My data"),
        ChartDataEntry(x: 1650936066, y: 4, data: "My data"),
        ChartDataEntry(x: 1651022466, y: -10, data: "My data")
    ]
    
    @State private var data5: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: -10, data: "My data"),
        ChartDataEntry(x: 1650590466, y: -10, data: "My data"),
        ChartDataEntry(x: 1650676866, y: -10, data: "My data"),
        ChartDataEntry(x: 1650763266, y: 5, data: "My data"),
        ChartDataEntry(x: 1650849666, y: 5, data: "My data"),
        ChartDataEntry(x: 1650936066, y: 5, data: "My data"),
        ChartDataEntry(x: 1651022466, y: 5, data: "My data")
    ]
    
    @State private var data6: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: 6, data: "My data"),
        ChartDataEntry(x: 1650590466, y: 6, data: "My data"),
        ChartDataEntry(x: 1650676866, y: 6, data: "My data"),
        ChartDataEntry(x: 1650763266, y: 6, data: "My data"),
        ChartDataEntry(x: 1650849666, y: 6, data: "My data"),
        ChartDataEntry(x: 1650936066, y: 6, data: "My data"),
        ChartDataEntry(x: 1651022466, y: 6, data: "My data")
    ]
    
    @State private var data7: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: -10, data: "My data"),
        ChartDataEntry(x: 1650590466, y: -10, data: "My data"),
        ChartDataEntry(x: 1650676866, y: -10, data: "My data"),
        ChartDataEntry(x: 1650763266, y: -10, data: "My data"),
        ChartDataEntry(x: 1650849666, y: 7, data: "My data"),
        ChartDataEntry(x: 1650936066, y: 7, data: "My data"),
        ChartDataEntry(x: 1651022466, y: -10, data: "My data")
    ]
    
    @State private var data8: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: 8, data: "My data"),
        ChartDataEntry(x: 1650590466, y: 8, data: "My data"),
        ChartDataEntry(x: 1650676866, y: 8, data: "My data"),
        ChartDataEntry(x: 1650763266, y: 8, data: "My data"),
        ChartDataEntry(x: 1650849666, y: -10, data: "My data"),
        ChartDataEntry(x: 1650936066, y: -10, data: "My data"),
        ChartDataEntry(x: 1651022466, y: -10, data: "My data")
    ]
    
    @State private var data9: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: -10, data: "My data"),
        ChartDataEntry(x: 1650590466, y: -10, data: "My data"),
        ChartDataEntry(x: 1650676866, y: -10, data: "My data"),
        ChartDataEntry(x: 1650763266, y: -10, data: "My data"),
        ChartDataEntry(x: 1650849666, y: -10, data: "My data"),
        ChartDataEntry(x: 1650936066, y: -10, data: "My data"),
        ChartDataEntry(x: 1651022466, y: -10, data: "My data")
    ]
    
    @State private var data10: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: 10, data: "My data"),
        ChartDataEntry(x: 1650590466, y: 10, data: "My data"),
        ChartDataEntry(x: 1650676866, y: -10, data: "My data"),
        ChartDataEntry(x: 1650763266, y: -10, data: "My data"),
        ChartDataEntry(x: 1650849666, y: 10, data: "My data"),
        ChartDataEntry(x: 1650936066, y: 10, data: "My data"),
        ChartDataEntry(x: 1651022466, y: 10, data: "My data")
    ]
    
    @State private var data11: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: 11, data: "My data"),
        ChartDataEntry(x: 1650590466, y: 11, data: "My data"),
        ChartDataEntry(x: 1650676866, y: 11, data: "My data"),
        ChartDataEntry(x: 1650763266, y: -10, data: "My data"),
        ChartDataEntry(x: 1650849666, y: -10, data: "My data"),
        ChartDataEntry(x: 1650936066, y: 11, data: "My data"),
        ChartDataEntry(x: 1651022466, y: -10, data: "My data")
    ]
    
    @State private var data12: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: -10, data: "My data"),
        ChartDataEntry(x: 1650590466, y: 12, data: "My data"),
        ChartDataEntry(x: 1650676866, y: -10, data: "My data"),
        ChartDataEntry(x: 1650763266, y: 12, data: "My data"),
        ChartDataEntry(x: 1650849666, y: -10, data: "My data"),
        ChartDataEntry(x: 1650936066, y: 12, data: "My data"),
        ChartDataEntry(x: 1651022466, y: -10, data: "My data")
    ]

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
//            Form {
            MultipleLineChart(cleanerFull:data1, drainClog:data2,highPres:data3,highAmps:data4,service:data5,maint:data6,lowWater:data7,timeDelay:data8,sleepCycle:data9,makingIce:data10,lowBin:data11,powerOn:data12).frame(width: 300, height: 300, alignment: .center)
//                Button("Add data") {
//                    let max = data.map(\.x).max() ?? 1628071200
//                    data.append(ChartDataEntry(x: max + 86400, y: Double.random(in: 1 ..< 500)))
//                }
//            }
        }
    }
}


struct ChartsMultipleLineChart_Previews: PreviewProvider {
    static var previews: some View {
        StateChartView()
    }
}

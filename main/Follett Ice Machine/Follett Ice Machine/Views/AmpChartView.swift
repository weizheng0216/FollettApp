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
    
    var body: some View {

        VStack(alignment: .center, spacing: 20) {
            MultipleLineChart(lowAmps: BTManager.minEntries, highAmps: BTManager.maxEntries).frame(width: 300, height: 300, alignment: .center)
        }
    }
    
//    var body: some View {
//        switch graph {
//        case 0:
//            VStack(alignment: .center, spacing: 20) {
////                LineChart(entries: [BTManager.minEntries, BTManager.minEntries]).frame(width: 300, height: 300, alignment: .center)
//                MultipleLineChart(lowAmps: BTManager.minEntries, highAmps: BTManager.maxEntries).frame(width: 300, height: 300, alignment: .center)
//            }
//        case 1:
//            VStack(alignment: .center, spacing: 20) {
////                LineChart(entries: BTManager.maxEntries).frame(width: 300, height: 300, alignment: .center)
//                MultipleLineChart(lowAmps: BTManager.minEntries, highAmps: BTManager.maxEntries).frame(width: 300, height: 300, alignment: .center)
//            }
//        default:
//            VStack(alignment: .center, spacing: 20) {
////                LineChart(entries: BTManager.minEntries).frame(width: 300, height: 300, alignment: .center)
//                MultipleLineChart(lowAmps: BTManager.minEntries, highAmps: BTManager.maxEntries).frame(width: 300, height: 300, alignment: .center)
//            }
//        }
//    }
}

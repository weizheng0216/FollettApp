//
//  GraphView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/3/22.
//

import SwiftUI

struct ChooseGraphView: View {
    @ObservedObject var BTManager: BLEManager
    
    var graph: Int
    
    var body: some View {
        switch graph {
        case 0:
            AmpChartView(BTManager: BTManager)
        case 1:
            StateChartView(BTManager: BTManager)
        case 2:
            ErrorStateChartView(BTManager: BTManager)
        default:
            AmpChartView(BTManager: BTManager)

        }
    }
        
}

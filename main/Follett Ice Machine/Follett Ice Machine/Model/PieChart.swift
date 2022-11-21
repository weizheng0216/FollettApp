//
//  UtilizationChart.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/2/22.
//  Support for SwiftUI, ability to display pie chart, intended to used for the utilization summary, but not used in the current app

import Foundation
import Charts
import SwiftUI

struct PieChart: UIViewRepresentable {
    let entries: [ChartDataEntry]
    let pieChart = PieChartView()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> PieChartView {
        pieChart.delegate = context.coordinator
        pieChart.noDataText = "No Data"
                        
        pieChart.drawEntryLabelsEnabled = true
    
        pieChart.usePercentValuesEnabled = true
        pieChart.legend.enabled = false
        
        pieChart.isUserInteractionEnabled = true
        
        return pieChart
    }
    
    func updateUIView(_ uiView: PieChartView, context: Context) {
        let dataSet = PieChartDataSet(entries: entries)
//        dataSet.label = "Utilization"
        dataSet.colors = ChartColorTemplates.vordiplom()
        dataSet.drawIconsEnabled = false
        
        dataSet.valueColors = [.black]
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        formatter.zeroSymbol = ""
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        
        dataSet.xValuePosition = .insideSlice
        dataSet.yValuePosition = .insideSlice
        
        uiView.data = PieChartData(dataSet: dataSet)
        
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent: PieChart
        
        init(parent: PieChart) {
            self.parent = parent
        }
    }
}

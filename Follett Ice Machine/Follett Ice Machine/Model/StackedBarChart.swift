//
//  BarChart.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 10/23/22.
//

import Charts
import SwiftUI

struct StackedBarChart: UIViewRepresentable {
    
    var power: [ChartDataEntry]
    var low: [ChartDataEntry]
    
    let stackedBarChart = BarChartView()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> BarChartView {
        stackedBarChart.delegate = context.coordinator
        stackedBarChart.noDataText = "No Data"
        stackedBarChart.fitBars = true
        
        stackedBarChart.leftAxis.axisMinimum = 0
        
        stackedBarChart.rightAxis.enabled = false
        
        stackedBarChart.xAxis.labelPosition = .bottom
        
        stackedBarChart.legend.drawInside = true
        stackedBarChart.legend.verticalAlignment = .top
        stackedBarChart.legend.horizontalAlignment = .right
        
        stackedBarChart.setScaleEnabled(false)
        stackedBarChart.isUserInteractionEnabled = false
        
        return stackedBarChart
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        let dataSet1 = BarChartDataSet(entries: power)
        let dataSet2 = BarChartDataSet(entries: low)
        
        dataSet1.label = "Power"
        dataSet1.colors = [.red]
        dataSet1.valueColors = [.black]
        dataSet1.valueFormatter = DefaultValueFormatter(decimals: 0)
        
        dataSet2.label = "Low"
        dataSet2.colors = [.blue]
        dataSet2.valueColors = [.red]
        dataSet2.valueFormatter = DefaultValueFormatter(decimals: 0)
        
        uiView.data = BarChartData(dataSets: [dataSet1, dataSet2])

        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent: StackedBarChart
        
        init(parent: StackedBarChart) {
            self.parent = parent
        }
    }
}

//
//  BarChart.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 10/23/22.
//  Support for SwiftUI, ability to display stacked bar chart, used for error st

import Charts
import SwiftUI

struct StackedBarChart: UIViewRepresentable {
    
    var yVals: [BarChartDataEntry]
    
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
        stackedBarChart.xAxis.labelRotationAngle = 45
        stackedBarChart.legend.drawInside = false
        stackedBarChart.legend.verticalAlignment = .top
        stackedBarChart.legend.horizontalAlignment = .right
        stackedBarChart.scaleXEnabled = true
        stackedBarChart.scaleYEnabled = false
        stackedBarChart.xAxis.valueFormatter = DateValueFormatter()
        stackedBarChart.isUserInteractionEnabled = true
        
        return stackedBarChart
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        
        // yVals format -> [x, [data]]
        let set = BarChartDataSet(entries: yVals, label: "Error State")
        
        set.valueFormatter = DefaultValueFormatter(decimals: 0)
        // each color is used for differnt mode
        set.colors = [  .gray,
                        .blue,
                        .yellow,
                        .red,
                        .green,
                        .brown,
                        .cyan,
                        .darkGray,
                        .magenta,
                        .orange,
                        .purple,
        ]
        set.stackLabels = ["Low Water", "High Pressure", "Current", "RS232", "RS485", "Chassis Leak", "Drip Tray Full", "Drain Clog", "Call for water", "Power Error"]
        
        uiView.data = BarChartData(dataSet: set)

        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent: StackedBarChart
        
        init(parent: StackedBarChart) {
            self.parent = parent
        }
    }
}

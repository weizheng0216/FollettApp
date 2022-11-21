//
//  MultipleLineChart.swift
//  Follett Ice Machine
//
//  Support for SwiftUI, ability to display multiple line chart, used for amp values

import Charts
import SwiftUI

struct MultipleLineChart: UIViewRepresentable {
    
    // array for min and max amps values
    var lowAmps: [ChartDataEntry]
    var highAmps: [ChartDataEntry]
    @State var x: Double = 0.0
    
    let multipleLineChart = LineChartView()

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> LineChartView {
        multipleLineChart.delegate = context.coordinator
        multipleLineChart.noDataText = "No Data"
        multipleLineChart.leftAxis.axisMinimum = 0
        multipleLineChart.rightAxis.enabled = false
        multipleLineChart.xAxis.labelPosition = .bottom
        multipleLineChart.xAxis.valueFormatter = DateValueFormatter()
        // rotating x axis (date) by 45 degress
        multipleLineChart.xAxis.labelRotationAngle = 45
        multipleLineChart.legend.enabled = false
        multipleLineChart.scaleXEnabled = true
        multipleLineChart.scaleYEnabled = false
        // able to zoom in and out
        multipleLineChart.pinchZoomEnabled = true
        multipleLineChart.animate(xAxisDuration: 2, easingOption: ChartEasingOption.linear)
        multipleLineChart.animate(yAxisDuration: 2, easingOption: ChartEasingOption.linear)
        
        return multipleLineChart
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        
        // two datasets for min and max
        let dataSet1 = LineChartDataSet(entries: lowAmps)
        let dataSet2 = LineChartDataSet(entries: highAmps)
    
        dataSet1.label = "Low Amps"
        // line for the min amp would be green
        dataSet1.colors = [.green]
        dataSet1.valueColors = [.blue]
        dataSet1.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataSet1.drawCirclesEnabled = true
        dataSet1.mode = .linear
        dataSet1.highlightEnabled = false
        
        dataSet2.label = "High Amps"
        // lin for the max amp would be red
        dataSet2.colors = [.red]
        dataSet2.valueColors = [.blue]
        dataSet2.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataSet2.drawCirclesEnabled = true
        dataSet2.mode = .linear
        dataSet2.highlightEnabled = false
        
        uiView.data = LineChartData(dataSets: [dataSet1, dataSet2])

        uiView.notifyDataSetChanged()
        
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent: MultipleLineChart
        
        init(parent: MultipleLineChart) {
            self.parent = parent
        }
    }
}

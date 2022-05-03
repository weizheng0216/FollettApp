////
////  Follett_Ice_MachineApp.swift
////  Follett Ice Machine
////
////  Created by Wei Zheng on 4/2/22.
////
//
//import Charts
//import SwiftUI
//
//struct TestChart: UIViewRepresentable {
//    let entries: [ChartDataEntry]
//    let lineChart = LineChartView()
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//    
//    func makeUIView(context: Context) -> LineChartView {
//        lineChart.delegate = context.coordinator
//        lineChart.noDataText = "No Data"
//         
//        lineChart.leftAxis.axisMinimum = 0
//        lineChart.rightAxis.enabled = false
//        
//        lineChart.xAxis.labelPosition = .bottom
//        lineChart.xAxis.valueFormatter = DateValueFormatter()
//        lineChart.xAxis.labelRotationAngle = 45
//        
//        lineChart.legend.enabled = false
//        
//        lineChart.scaleXEnabled = true
//        lineChart.scaleYEnabled = false
//        lineChart.pinchZoomEnabled = true
//        lineChart.animate(xAxisDuration: 2, easingOption: ChartEasingOption.linear)
//        lineChart.animate(yAxisDuration: 2, easingOption: ChartEasingOption.linear)
//        
//        return lineChart
//    }
//    
//    func updateUIView(_ uiView: LineChartView, context: Context) {
////        let dataSet = LineChartDataSet(entries: entries)
//        
//        let chartData = LineChartData()
//        for i in 0 ..< 100.count {
//                createDataSet(data: chartData, index: i, offset: 0)
//        }
//        uiView.data = chartData
//    
////        dataSet.label = "Transactions"
////        dataSet.colors = [.red]
////        dataSet.valueColors = [.blue]
////        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)
////        dataSet.drawCirclesEnabled = true
////        dataSet.mode = .cubicBezier
////        dataSet.highlightEnabled = false
////
////        uiView.data = LineChartData(dataSet: dataSet)
//        
//        uiView.notifyDataSetChanged()
//        
//    }
//    
//    func createDataSet(data: LineChartData, index: Int, offset: Int) {
//            
//            var yValues : [ChartDataEntry] = [ChartDataEntry]()
//            
//            for i in offset ..< _myLabels.count {
//                let point = _myDataCollection[index][i]
//                if(point == 0) {
//                    if( (i + 1) < _myLabels.count) {
//                        createDataSet(data: data, index: index, offset: i + 1)
//                    }
//                    break
//                } else {
//                    yValues.append(ChartDataEntry(x: i, y: point))
//                }
//            }
//            
//            let ds = LineChartDataSet(values: yValues, label: nil)
//            let lc = _myColorCollection[index]
//            ds.setColor(lc)
//            ds.lineWidth = 1.0
//            ...etc...
//            data.addDataSet(ds)
//        }
//    
//    class Coordinator: NSObject, ChartViewDelegate {
//        let parent: LineChart
//        
//        init(parent: LineChart) {
//            self.parent = parent
//        }
//    }
//}

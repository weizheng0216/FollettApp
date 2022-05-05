////
////  Follett_Ice_MachineApp.swift
////  Follett Ice Machine
////
////  Created by Wei Zheng on 4/2/22.
////
//
//// not longer used
//
//import Charts
//import SwiftUI
//
//struct MultipleLineChart: UIViewRepresentable {
//    let cleanerFull: [ChartDataEntry]
//    let drainClog: [ChartDataEntry]
//    let highPres: [ChartDataEntry]
//    let highAmps: [ChartDataEntry]
//    let service: [ChartDataEntry]
//    let maint: [ChartDataEntry]
//    let lowWater: [ChartDataEntry]
//    let timeDelay: [ChartDataEntry]
//    let sleepCycle: [ChartDataEntry]
//    let makingIce: [ChartDataEntry]
//    let lowBin: [ChartDataEntry]
//    let powerOn: [ChartDataEntry]
//
//    let multipleLineChart = LineChartView()
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//
//    func makeUIView(context: Context) -> LineChartView {
//        multipleLineChart.delegate = context.coordinator
//        multipleLineChart.noDataText = "No Data"
//
//        multipleLineChart.leftAxis.axisMinimum = 0
//        multipleLineChart.rightAxis.enabled = false
//
//        multipleLineChart.xAxis.labelPosition = .bottom
//        multipleLineChart.xAxis.valueFormatter = DateValueFormatter()
//        multipleLineChart.xAxis.labelRotationAngle = 45
//
////        multipleLineChart.legend.enabled = false
//
//        multipleLineChart.scaleXEnabled = true
//        multipleLineChart.scaleYEnabled = false
//        multipleLineChart.pinchZoomEnabled = true
////        multipleLineChart.animate(xAxisDuration: 2, easingOption: ChartEasingOption.linear)
////        multipleLineChart.animate(yAxisDuration: 2, easingOption: ChartEasingOption.linear)
//
//        return multipleLineChart
//    }
//
//    func updateUIView(_ uiView: LineChartView, context: Context) {
//        let dataSet1 = LineChartDataSet(entries: cleanerFull)
//        let dataSet2 = LineChartDataSet(entries: drainClog)
//        let dataSet3 = LineChartDataSet(entries: highPres)
//        let dataSet4 = LineChartDataSet(entries: highAmps)
//        let dataSet5 = LineChartDataSet(entries: service)
//        let dataSet6 = LineChartDataSet(entries: maint)
//        let dataSet7 = LineChartDataSet(entries: lowWater)
//        let dataSet8 = LineChartDataSet(entries: timeDelay)
//        let dataSet9 = LineChartDataSet(entries: sleepCycle)
//        let dataSet10 = LineChartDataSet(entries: makingIce)
//        let dataSet11 = LineChartDataSet(entries: lowBin)
//        let dataSet12 = LineChartDataSet(entries: powerOn)
//
//        dataSet1.label = "CLEANER FULL"
////        dataSet1.colors = [.red]
//        dataSet1.colors = [.red]
//        dataSet1.valueFormatter = DefaultValueFormatter(decimals: 0)
//        dataSet1.drawCirclesEnabled = false
//        dataSet1.mode = .stepped
//        dataSet1.highlightEnabled = false
//        dataSet1.drawValuesEnabled = false
//
//        dataSet2.label = "DRAIN CLOG"
//        dataSet2.colors = [.orange]
//        dataSet2.valueFormatter = DefaultValueFormatter(decimals: 0)
//        dataSet2.drawCirclesEnabled = false
//        dataSet2.mode = .stepped
//        dataSet2.highlightEnabled = false
//        dataSet2.drawValuesEnabled = false
//
//        dataSet3.label = "HIGH PRES"
//        dataSet3.colors = [.yellow]
//        dataSet3.valueFormatter = DefaultValueFormatter(decimals: 0)
//        dataSet3.drawCirclesEnabled = false
//        dataSet3.mode = .stepped
//        dataSet3.highlightEnabled = false
//        dataSet3.drawValuesEnabled = false
//
//        dataSet4.label = "HIGH AMPS"
//        dataSet4.colors = [.green]
//        dataSet4.valueFormatter = DefaultValueFormatter(decimals: 0)
//        dataSet4.drawCirclesEnabled = false
//        dataSet4.mode = .stepped
//        dataSet4.highlightEnabled = false
//        dataSet4.drawValuesEnabled = false
//
//        dataSet5.label = "SERVICE"
//        dataSet5.colors = [.blue]
//        dataSet5.valueFormatter = DefaultValueFormatter(decimals: 0)
//        dataSet5.drawCirclesEnabled = false
//        dataSet5.mode = .stepped
//        dataSet5.highlightEnabled = false
//        dataSet5.drawValuesEnabled = false
//
//        dataSet6.label = "MAINT/CLEAN"
//        dataSet6.colors = [.brown]
//        dataSet6.valueFormatter = DefaultValueFormatter(decimals: 0)
//        dataSet6.drawCirclesEnabled = false
//        dataSet6.mode = .stepped
//        dataSet6.highlightEnabled = false
//        dataSet6.drawValuesEnabled = false
//
//        dataSet7.label = "LOW WATER"
//        dataSet7.colors = [.purple]
//        dataSet7.valueFormatter = DefaultValueFormatter(decimals: 0)
//        dataSet7.drawCirclesEnabled = false
//        dataSet7.mode = .stepped
//        dataSet7.highlightEnabled = false
//        dataSet7.drawValuesEnabled = false
//
//        dataSet8.label = "TIME DELAY"
//        dataSet8.colors = [.systemIndigo]
//        dataSet8.valueFormatter = DefaultValueFormatter(decimals: 0)
//        dataSet8.drawCirclesEnabled = false
//        dataSet8.mode = .stepped
//        dataSet8.highlightEnabled = false
//        dataSet8.drawValuesEnabled = false
//
//        dataSet9.label = "SLEEP CYCLE"
//        dataSet9.colors = [.gray]
//        dataSet9.valueFormatter = DefaultValueFormatter(decimals: 0)
//        dataSet9.drawCirclesEnabled = false
//        dataSet9.mode = .stepped
//        dataSet9.highlightEnabled = false
//        dataSet9.drawValuesEnabled = false
//
//        dataSet10.label = "MAKING ICE"
//        dataSet10.colors = [.systemMint]
//        dataSet10.valueFormatter = DefaultValueFormatter(decimals: 0)
//        dataSet10.drawCirclesEnabled = false
//        dataSet10.mode = .stepped
//        dataSet10.highlightEnabled = false
//        dataSet10.drawValuesEnabled = false
//
//        dataSet11.label = "LOW BIN"
//        dataSet11.colors = [.systemTeal]
//        dataSet11.valueFormatter = DefaultValueFormatter(decimals: 0)
//        dataSet11.drawCirclesEnabled = false
//        dataSet11.mode = .stepped
//        dataSet11.highlightEnabled = false
//        dataSet11.drawValuesEnabled = false
//
//        dataSet12.label = "POWER"
//        dataSet12.colors = [.white]
//        dataSet12.valueFormatter = DefaultValueFormatter(decimals: 0)
//        dataSet12.drawCirclesEnabled = false
//        dataSet12.mode = .stepped
//        dataSet12.highlightEnabled = false
//        dataSet12.drawValuesEnabled = false
//
//
//        uiView.data = LineChartData(dataSets: [dataSet1,dataSet2,dataSet3,dataSet4,dataSet5,dataSet6,dataSet7,dataSet8,dataSet9,dataSet10,dataSet11,dataSet12])
////        uiView.data = LineChartData(dataSets: [dataSet1,dataSet2,dataSet3,dataSet4,dataSet5,dataSet6,dataSet7,dataSet8,dataSet9,dataSet10,dataSet11,dataSet12])
//
//        uiView.notifyDataSetChanged()
//
//    }
//
//    class Coordinator: NSObject, ChartViewDelegate {
//        let parent: MultipleLineChart
//
//        init(parent: MultipleLineChart) {
//            self.parent = parent
//        }
//    }
//}

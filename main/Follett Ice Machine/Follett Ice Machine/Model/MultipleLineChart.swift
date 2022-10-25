import Charts
import SwiftUI

struct MultipleLineChart: UIViewRepresentable {
    
    var lowAmps: [ChartDataEntry]
    var highAmps: [ChartDataEntry]
    @State var x: Double = 0.0
    
    let multipleLineChart = LineChartView()
    //
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
        multipleLineChart.xAxis.labelRotationAngle = 45
        
        multipleLineChart.legend.enabled = false
        
        multipleLineChart.scaleXEnabled = true
        multipleLineChart.scaleYEnabled = false
        multipleLineChart.pinchZoomEnabled = true
        multipleLineChart.animate(xAxisDuration: 2, easingOption: ChartEasingOption.linear)
        multipleLineChart.animate(yAxisDuration: 2, easingOption: ChartEasingOption.linear)
        
        return multipleLineChart
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        
        let dataSet1 = LineChartDataSet(entries: lowAmps)
        let dataSet2 = LineChartDataSet(entries: highAmps)
    
        dataSet1.label = "Low Amps"
        dataSet1.colors = [.green]
        dataSet1.valueColors = [.blue]
        dataSet1.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataSet1.drawCirclesEnabled = true
        dataSet1.mode = .cubicBezier
        dataSet1.highlightEnabled = false
        
        dataSet2.label = "High Amps"
        dataSet2.colors = [.red]
        dataSet2.valueColors = [.blue]
        dataSet2.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataSet2.drawCirclesEnabled = true
        dataSet2.mode = .cubicBezier
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

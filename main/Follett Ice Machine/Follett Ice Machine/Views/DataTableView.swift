//
//  DataTableView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/4/22.
//

import SwiftUI
import Tabler

struct DataPoint: Identifiable {
    var id: Double
    var value: Double
}

struct DataTableView: View {
    
//    @State private var data: [DataPoint] = []
    var rawData: [[Double]]
    
    init(rawData: [[Double]]){
        self.rawData = rawData
    }
    
    
    func convertToDataPoint(rawData:[[Double]]) -> [DataPoint]{
        var tempData: [DataPoint] = []
        
        for(_, values) in rawData.enumerated() {
            tempData.append(DataPoint(id: values[0], value: values[1]))
        }
        
        return tempData
    }
    
    private var gridItems: [GridItem] = [
        GridItem(.flexible(minimum: 50), spacing: 0, alignment: .center),
        GridItem(.flexible(minimum: 50), spacing: 0, alignment: .center),
    ]

    private typealias Context = TablerContext<DataPoint>

    private func header(ctx: Binding<Context>) -> some View {
        LazyVGrid(columns: gridItems) {
            Text("Time")
            Text("Value")
        }
    }
    
    private func row(datapoint: DataPoint) -> some View {
        LazyVGrid(columns: gridItems) {
            Text(DateValueFormatter().stringForValue(datapoint.id, axis: nil))
            Text(String(format: "%d", datapoint.value))
        }
    }

    var body: some View {
        TablerList(header: header,
                   row: row,
                   results: convertToDataPoint(rawData: rawData))
    }
}

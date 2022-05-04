//
//  DataTableView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/4/22.
//

import SwiftUI
import Tabler

struct DataPoint: Identifiable {
    var id: Int
    var value: Int
}

struct DataTableView: View {
    
//    @State private var data: [DataPoint] = []
    var rawData: [[Int]]
    
    init(rawData: [[Int]]){
        self.rawData = rawData
    }
    
    
    func convertToDataPoint(rawData:[[Int]]) -> [DataPoint]{
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
            Text("Name")
        }
    }
    
    private func row(datapoint: DataPoint) -> some View {
        LazyVGrid(columns: gridItems) {
            Text(String(format: "%d", datapoint.id))
            Text(String(format: "%d", datapoint.value))
        }
    }

    var body: some View {
        TablerList(header: header,
                   row: row,
                   results: convertToDataPoint(rawData: rawData))
    }
}


//struct DataTableView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            DataTableView(rawData: [[1,2], [3,3]])
//        }
//    }
//}
//

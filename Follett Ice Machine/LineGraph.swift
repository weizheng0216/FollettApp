//
//  LineGraph.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/21/22.
//

import SwiftUI
import SwiftUICharts

struct LineGraph: View {
    var body: some View {
        ScrollView{
            VStack{
                LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen")
//                LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen")
//                LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen")
//                LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen")
            }
            
        }
    }
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        LineGraph()
    }
}

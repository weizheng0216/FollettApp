////
////  ContentView.swift
////  Follett Ice Machine
////
////  Created by Wei Zheng on 4/14/22.
////
//
//import SwiftUI
//
////struct NameView: View {
////
////}
//
//struct ContentView: View {
////    var body: some View {
////        Text("Hello, world!")
////            .padding()
////    }
//
//
//    var body: some View {
//
////        VStack {
////            ForEach(statusLight) { status in
////                Text(stats)
////            }
////        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    let statusLight = ["Cleaner Full", "Drain Clog", "High Pres", "High Amps", "Service", "Maint/Clean", "Low Water", "Time Delay", "Sleep Cycle", "Making Ice", "Low Bin", "Power On"]
    @State var tabIndex:Int = 0
    var body: some View {
        
        TabView(selection: $tabIndex) {
            
            NavigationView {
                VStack(spacing: 40) {
                    VStack {
                        Text("Status Light")
                        .font(.title)
                        Text("SN# 12345")
                    }
                    
                    VStack{
                        ForEach(statusLight, id: \.self) { light in
                            HStack{
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 10, height: 10)
                                Text(light.uppercased())
                                    .frame(width: 130, alignment: .leading)
                            }
                        }
                    }
                    
                }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Image("logo-blue")
                            }
                        }
                    }
                }.tabItem {
                    Group{
                        Image(systemName: "chart.bar")
                        Text("Status")
                    }
                }.tag(0)
            
//          
           
           

            LineCharts().tabItem { Group{
                    Image(systemName: "waveform.path.ecg")
                    Text("Line charts")
                }}.tag(1)
            PieCharts().tabItem { Group{
                    Image(systemName: "chart.pie")
                    Text("Pie charts")
                }}.tag(2)
            LineChartsFull().tabItem { Group{
                Image(systemName: "waveform.path.ecg")
                Text("Data Graph")
            }}.tag(3)
        }
    }
}

struct BarCharts:View {
    var body: some View {
        VStack{
            HStack{
                LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title", dropShadow: false)
                LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title", dropShadow: false)
            }
            HStack{
                LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title", dropShadow: false)
                LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title", dropShadow: false)
            }
        }
    }
}

struct LineCharts:View {
    var body: some View {
        VStack{
            LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title")
        }
    }
}

struct PieCharts:View {
    var body: some View {
        VStack{
            PieChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title")
        }
    }
}

struct LineChartsFull: View {
    var body: some View {
        VStack{
            LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen").padding()
            // legend is optional, use optional .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

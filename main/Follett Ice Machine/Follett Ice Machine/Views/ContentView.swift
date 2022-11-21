// the "main" of the app, control all selection of all different tab

import SwiftUI
import Charts


struct ContentView: View {
    
    // control the botton tab switch
    @State var tabIndex:Int = 0
    @State private var selectedGraph: Int = 0
    
    @ObservedObject var bleManager = BLEManager()
    @ObservedObject var iceMachineState = IceMachineStatus()
    
//    @State var minAmpData: [[Double]] = []
//    @State var maxAmpData: [[Double]] = []
    
    var body: some View {
        
        
        TabView(selection: $tabIndex) {
        
            // first tab: status light
            NavigationView{
                StatusLightView(BTManager: self.bleManager)
            }
            .tabItem {
                Group{
                    Image(systemName: "chart.bar")
                    Text("Status")
                }}
            .tag(0)
            
            // second tab: dipSwitch view
            NavigationView{
                DipSwitchView(BTManager: self.bleManager)
            }
            .tabItem {
                Group{
                    Image(systemName: "switch.2")
                    Text("Dip Switches")
                }}
            .tag(1)
            
            // third tab: 3-in-1 graphs
            NavigationView{
                VStack{
                    
                    Picker("Graph", selection: $selectedGraph) {
                        Text("Amps").tag(0)
                        Text("Mode").tag(1)
                        Text("Error State").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(10)
                    
                    Spacer()
                    
                    ChooseGraphView(BTManager: self.bleManager, graph: selectedGraph)
                        .frame(width: 300, height: 350, alignment: .center)
                    
                    Spacer()
                }
                .navigationTitle("Graph")
            }
            .tabItem { Group{
                Image(systemName: "clock")
                Text("State Graph")
            }}
            .tag(2)
            
            // fourth tabl: list of all the data tables
            NavigationView {
                Form {
                    Section(header: Text("Auger Current")) {
                        
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.maxAmpData, tableName: "Max Amp")
                                .navigationBarTitle("Max Auger Current")
                        ) { Text("Max Auger Current")}
                        
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.minAmpData, tableName: "Min Amp")
                                .navigationBarTitle("Min Auger Current")
                        ) { Text("Min Auger Current")}
                        
                    }
//
                    Section(header: Text("LED Reading")){
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.led1Data, tableName: "LED1 Reading")
                                .navigationBarTitle("LED1 Reading")
                        ) { Text("LED1 Reading")}

                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.led2Data, tableName: "LED2 Reading")
                                .navigationBarTitle("LED2 Reading")
                        ) { Text("LED2 Reading")}
                    }
                    
                    Section(header: Text("Error Reading")){
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.errorData, tableName: "Error State")
                                .navigationBarTitle("Error High Reading")
                        ) { Text("Error High Reading")}
                    }

                    Section(header: Text("Dip Switch Reading")){
//
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.dipSwitchData, tableName: "Dip Switch Reading")
                                .navigationBarTitle("Dip Switch Reading")
                        ) { Text("Dip Switch Reading")}
                    }

                    Section(header: Text("Mode Reading")){
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.modeData, tableName: "Mode")
                                .navigationBarTitle("Mode Reading")
                        ) { Text("Mode Reading")}

                    }
                }
            }
            .tabItem { Group{
                Image(systemName: "tablecells.badge.ellipsis")
                Text("Data")
            }}
            .tag(3)
    
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


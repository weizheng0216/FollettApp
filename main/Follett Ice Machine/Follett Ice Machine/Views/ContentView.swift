import SwiftUI
import Charts


struct ContentView: View {
    
    
    @State var tabIndex:Int = 0
    @State private var selectedGraph: Int = 0
    
    @ObservedObject var bleManager = BLEManager()
    @ObservedObject var iceMachineState = IceMachineStatus()
    
    @State var minAmpData: [[Double]] = []
    @State var maxAmpData: [[Double]] = []
    
    var body: some View {
        
        
        TabView(selection: $tabIndex) {
        
            NavigationView{
                StatusLightView(BTManager: self.bleManager)
            }
            .tabItem {
                Group{
                    Image(systemName: "chart.bar")
                    Text("Status")
                }}
            .tag(0)
            
//            NavigationView{
//
//                VStack{
//                    AmpChartView(BTManager: bleManager, entries: $data)
//                        .navigationTitle("Amp Graph")
//                }
//            }
//            .tabItem { Group{
//                Image(systemName: "waveform.path.ecg")
//                Text("Amp Graph")
//            }}
//            .tag(1)
            NavigationView{
                DipSwitchView(BTManager: self.bleManager)
            }
            .tabItem {
                Group{
                    Image(systemName: "switch.2")
                    Text("Dip Switches")
                }}
            .tag(1)
            
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
            
            NavigationView {
                Form {
                    Section(header: Text("Auger Current")) {
                        
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.maxAmpData)
                                .navigationBarTitle("Max Auger Current")
                        ) { Text("Max Auger Current")}
                        
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.minAmpData)
                                .navigationBarTitle("Min Auger Current")
                        ) { Text("Min Auger Current")}
                        
//                        Spacer()
                    }
                    Section(header: Text("LED Reading")){
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.led1Data)
                                .navigationBarTitle("LED1 Reading")
                        ) { Text("LED1 Reading")}
                        
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.led2Data)
                                .navigationBarTitle("LED2 Reading")
                        ) { Text("LED2 Reading")}
                        
                        
                    }
                    
                    Section(header: Text("Error Reading")){
//                        Spacer()
                        
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.errHighData)
                                .navigationBarTitle("Error High Reading")
                        ) { Text("Error High Reading")}
                    }
                    
                    Section(header: Text("Dip Switch Reading")){
//                        Spacer()
                        
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.dipSwitchData)
                                .navigationBarTitle("Dip Switch Reading")
                        ) { Text("Dip Switch Reading")}
                    }
                    
                    Section(header: Text("Mode Reading")){
                        NavigationLink(
                            destination: DataTableView(rawData: bleManager.modeData)
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


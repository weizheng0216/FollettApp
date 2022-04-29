import SwiftUI
import Charts

struct ContentView: View {
    let statusLight = ["Cleaner Full", "Drain Clog", "High Pres", "High Amps", "Service", "Maint/Clean", "Low Water", "Time Delay", "Sleep Cycle", "Making Ice", "Low Bin", "Power On"]
    
    @State var tabIndex:Int = 0
    @State private var showingModel = false
    @ObservedObject var bleManager = BLEManager()
    
    var body: some View {
        
        TabView(selection: $tabIndex) {
            
            NavigationView{
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
                    
                    Button(action: {
                        self.bleManager.startScanning()
                        showingModel = true }) {
                            Text("Connect to a Ice Machine")
                        }
                    .sheet(isPresented: $showingModel, onDismiss: {
                        self.bleManager.stopScanning()
                        self.bleManager.peripherals.removeAll()
                    }) {
                        ScanView(BTManager: bleManager, isPresented: $showingModel)
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

            VStack{
                Spacer()
                VStack{
                    Text("Amp Graph")
                    ChartsLineChart()
                }
                
                Spacer()
                
            }.tabItem { Group{
                    Image(systemName: "waveform.path.ecg")
                    Text("Amp charts")
                }}.tag(1)
            
//            ScanView(BTManager: bleManager, isPresented: $showingModel).tabItem { Group{
//                    Image(systemName: "chart.pie")
//                    Text("Pie charts")
//                }}.tag(2)
//            LineChartsFull().tabItem { Group{
//                Image(systemName: "waveform.path.ecg")
//                Text("Data Graph")
//            }}.tag(3)
        }
    }
}

struct ChartsLineChart: View {
    @State private var data: [ChartDataEntry] = [
        ChartDataEntry(x: 1650504066, y: 312, data: "My data"),
        ChartDataEntry(x: 1650590466, y: 189, data: "My data"),
        ChartDataEntry(x: 1650676866, y: 129, data: "My data"),
        ChartDataEntry(x: 1650763266, y: 129, data: "My data"),
        ChartDataEntry(x: 1650849666, y: 289, data: "My data"),
        ChartDataEntry(x: 1650936066, y: 99, data: "My data"),
        ChartDataEntry(x: 1651022466, y: 67, data: "My data")
    ]

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
//            Form {
            LineChart(entries: data).frame(width: 300, height: 300, alignment: .center)
//                Button("Add data") {
//                    let max = data.map(\.x).max() ?? 1628071200
//                    data.append(ChartDataEntry(x: max + 86400, y: Double.random(in: 1 ..< 500)))
//                }
//            }
        }
    }
}




struct ScanView: View {
    
    @ObservedObject var BTManager: BLEManager
    @Binding var isPresented: Bool

    var body: some View {
        
        NavigationView {
            List(BTManager.peripherals) { peripheral in
                HStack {
                    Text(peripheral.name)
                    Spacer()
                    Text(String(peripheral.rssi))
                }
            }.frame(height: 300)
            .navigationBarTitle(Text("Sheet View"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    isPresented = false
                }) {
                    Text("Done").bold()
                })
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



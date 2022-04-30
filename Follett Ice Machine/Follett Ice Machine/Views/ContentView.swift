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
            
        NavigationView{

            VStack{
                ChartsLineChart()
                    .navigationTitle("Amp Graph")
            }
        }
            .tabItem { Group{
                Image(systemName: "waveform.path.ecg")
                Text("Amp charts")
        }}.tag(1)
        
            
//            ScanView(BTManager: bleManager, isPresented: $showingModel).tabItem { Group{
//                    Image(systemName: "chart.pie")
//                    Text("Pie charts")
//                }}.tag(2)
            
        NavigationView{
            ChartsMultipleLineChart()
                .navigationTitle("State Graph")
        }
            .tabItem { Group{
                Image(systemName: "clock")
                Text("State Graph")
            }}.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



import SwiftUI
import Charts

struct ContentView: View {
    
    
    @State var tabIndex:Int = 0
    @ObservedObject var bleManager = BLEManager()
    @ObservedObject var iceMachineState = IceMachineStatus()
    
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
            
            NavigationView{

                VStack{
                    AmpChartView()
                        .navigationTitle("Amp Graph")
                }
            }
            .tabItem { Group{
                Image(systemName: "waveform.path.ecg")
                Text("Amp charts")
            }}
            .tag(1)
            
            NavigationView{
                StateChartView()
                    .navigationTitle("State Graph")
            }
            .tabItem { Group{
                Image(systemName: "clock")
                Text("State Graph")
            }}
            .tag(2)
            
            NavigationView{
                UtilizationChartView ()
                    .navigationTitle("Utilization Graph")
            }
            .tabItem { Group{
                Image(systemName: "chart.pie")
                Text("Utilization Graph")
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



import SwiftUI
import Charts
import WebKit

struct ContentView: View {
    
    
    @State var tabIndex:Int = 0
    @ObservedObject var bleManager = BLEManager()
    @ObservedObject var iceMachineState = IceMachineStatus()
    @State var text = """
    <!DOCTYPE html>
    <html>
      <head>
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0 maximum-scale=1.0 user-scalable=no\" charset=\"utf-8\" />
        <title>Embedding Vega-Lite</title>
        <script src="https://cdn.jsdelivr.net/npm/vega@5.21.0"></script>
        <script src="https://cdn.jsdelivr.net/npm/vega-lite@5.2.0"></script>
        <script src="https://cdn.jsdelivr.net/npm/vega-embed@6.20.2"></script>
      </head>
      <body>
       <div style = "height="300" width="400" id="vis"></div>

        <script type="text/javascript">
          var yourVlSpec = {
             "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
               "description": "A simple bar chart with ranged data (aka Gantt Chart).",
               "title": {
                 "text": "A Simple Bar Chart"
               },
               "data": {
                 "values": [
                   {"task": "Cleaner Full", "start": 11, "end": 12},
                   {"task": "Drain Clog", "start": 13, "end": 15},
                   {"task": "High Pres", "start": 1, "end": 7},
                   {"task": "High Amps", "start": 1, "end": 2},
                   {"task": "Service", "start": 7, "end": 10},
                   {"task": "Maint/Clean", "start": 11, "end": 13},
                   {"task": "Low Water", "start": 9, "end": 10},
                   {"task": "Time Delay", "start": 2, "end": 3},
                   {"task": "Sleep Cycle", "start": 4, "end": 6},
                   {"task": "Making Ice", "start": 1, "end": 7},
                   {"task": "Low Bin", "start": 2, "end": 4},
                   {"task": "Power On", "start": 1, "end": 13}
                 ]
               },
               "mark": "bar",
               "encoding": {
                 
                 "y": {"field": "task", "type": "ordinal"},
                 "x": {"field": "start", "type": "quantitative"},
                 "x2": {"field": "end"}
               }
          };
          vegaEmbed('#vis', yourVlSpec);
        </script>
      </body>
    </html>
    """
    
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
//                StateChartView()
                WebView(htmlString: $text)
                    .frame(width: 300, height: 400, alignment: .center)
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

struct WebView: UIViewRepresentable {
    
    @Binding var htmlString: String
    var webView: WKWebView?
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if (scrollView.contentOffset.x > 0){
                scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
            }
         }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    init (htmlString: Binding<String>) {
        self.webView = WKWebView()
        self._htmlString = htmlString
        webView?.scrollView.showsHorizontalScrollIndicator = false
        webView?.scrollView.showsVerticalScrollIndicator = false
        webView?.scrollView.pinchGestureRecognizer?.isEnabled = false
        webView?.scrollView.bounces = false
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView?.scrollView.delegate = context.coordinator
        return webView!
    }
   
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
}

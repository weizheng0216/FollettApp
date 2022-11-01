//
//  GraphView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/3/22.
//

import SwiftUI

struct ChooseGraphView: View {
    @ObservedObject var BTManager: BLEManager
    @State var htmlString = """
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
    
    var graph: Int
    
    var body: some View {
        switch graph {
        case 0:
//            GanttView(htmlString: $htmlString)
            StateChartView(BTManager: BTManager)
        case 1:
            ErrorStateChartView(BTManager: BTManager)
        default:
            StateChartView(BTManager: BTManager)
//            GanttView(htmlString: $htmlString)
        }
    }
        
}

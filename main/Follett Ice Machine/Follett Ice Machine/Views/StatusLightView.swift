//
//  StatusLightView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/2/22.
//  The view that displayed all the LED status

import SwiftUI

struct StatusLightView: View {
    
    @ObservedObject var BTManager: BLEManager
    
    // getting the status array from IceMachineStatus class
    @ObservedObject var status = IceMachineStatus.shared
    @State private var showingModel = false
    
    // string array used to draw the view
    let statusLight = ["Power On", "Low Bin", "Making Ice", "Sleep Cycle", "Time Delay", "Low Water", "Maint/Clean", "Service", "High Amps", "High Pres", "Drain Clog", "Cleaner Full"]
    
    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Status Light")
                .font(.title)
                Text("SN# 12345")
            }
            
            VStack{
                // for each element in the statusLight array, we will draw a circle in front of the text like the real ice machine
                ForEach(Array(zip(statusLight, status.statusArray).enumerated()), id: \.0) { index, item in
                    
                    HStack{
                        if 0...3 ~= index {
                            // the circle with full color indicating on, 0.2 opacity indicating off
                            Circle()
                                .fill(item.1==1 ? Color.green : Color.green.opacity(0.2))
                                .frame(width: 10, height: 10)
                        } else if 4...6 ~= index {
                            Circle()
                                .fill(item.1==1 ? Color.yellow : Color.yellow.opacity(0.2))
                                .frame(width: 10, height: 10)
                        } else {
                            Circle()
                                .fill(item.1==1 ? Color.red : Color.red.opacity(0.2))
                                .frame(width: 10, height: 10)
                        }
                        
                        Text(item.0.uppercased())
                            .frame(width: 130, alignment: .leading)
                    }
                }
            }
            
            VStack(spacing: 5){
                Button(action: {
                    // when the button was pressed, trigger the scanning function in BLEManager
                    self.BTManager.startScanning()
                    showingModel = true }) {
                        Text("Connect to a Ice Machine")
                    }
                // trigger the pop up model to see the list of exisiting ble
                .sheet(isPresented: $showingModel, onDismiss: {
                    self.BTManager.stopScanning()
                    self.BTManager.peripherals.removeAll()
                }) {
                    ScanView(BTManager: BTManager, isPresented: $showingModel)
                }
                // button to terminate the ble connection
                Button(action: {
                    self.BTManager.disconnect()
                    showingModel = false
                }) { Text("Disconnect from the Ice Machine") }
        
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
    }
}

//
//  StatusLightView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/2/22.
//

import SwiftUI

struct StatusLightView: View {
    
    @ObservedObject var BTManager: BLEManager
    
    @ObservedObject var status = IceMachineStatus.shared
    @State private var showingModel = false
    
    let statusLight = ["Cleaner Full", "Drain Clog", "High Pres", "High Amps", "Service", "Maint/Clean", "Low Water", "Time Delay", "Sleep Cycle", "Making Ice", "Low Bin", "Power On"]
    
    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Status Light")
                .font(.title)
                Text("SN# 12345")
            }
            
            VStack{
                ForEach(Array(zip(statusLight, status.statusArray).enumerated()), id: \.0) { index, item in
                    
                    
                    
                    HStack{
                        if 0...4 ~= index {
                            Circle()
                                .fill(item.1==1 ? Color.red : Color.red.opacity(0.2))
                                .frame(width: 10, height: 10)
                        } else if 4...9 ~= index {
                            Circle()
                                .fill(item.1==1 ? Color.yellow : Color.yellow.opacity(0.2))
                                .frame(width: 10, height: 10)
                        } else {
                            Circle()
                                .fill(item.1==1 ? Color.green : Color.green.opacity(0.2))
                                .frame(width: 10, height: 10)
                        }
                        
                        Text(item.0.uppercased())
                            .frame(width: 130, alignment: .leading)
                    }
                }
            }
            
            VStack(spacing: 5){
                Button(action: {
                    self.BTManager.startScanning()
                    showingModel = true }) {
                        Text("Connect to a Ice Machine")
                    }
                .sheet(isPresented: $showingModel, onDismiss: {
                    self.BTManager.stopScanning()
                    self.BTManager.peripherals.removeAll()
                }) {
                    ScanView(BTManager: BTManager, isPresented: $showingModel)
                }
                
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

//
//  ScanView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/29/22.
//  Modal that display all existing ble

import SwiftUI

struct ScanView: View {
    
    @ObservedObject var BTManager: BLEManager
    @Binding var isPresented: Bool
    
    var body: some View {
        
        NavigationView {
            // display all existing ble
            List(BTManager.peripherals) { peripheral in
                HStack {
                    // name of the ble devices
                    Text(peripheral.name)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
//                    print(peripheral.rssi)
//                    BTManager.writeOutgoingValue(data: "Hello World")
                    
                    // comment out this if dynamic, change in blemanager
//                    BTManager.connect(peripheralName: peripheral.name)
//                    if peripheral.name == "Follett Ice Machine" {
//                        print(true)
//                        BTManager.stopScanning()
                        
//                    }
                }
            }
            
            .navigationBarTitle(Text("Scanning..."), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    isPresented = false
                }) {
                    Text("Done").bold()
                })
        }
    }
}

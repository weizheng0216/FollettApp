//
//  ScanView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/29/22.
//

import SwiftUI

struct ScanView: View {
    
    @ObservedObject var BTManager: BLEManager
    @Binding var isPresented: Bool

    var body: some View {
        
        NavigationView {
            List(BTManager.peripherals) { peripheral in
                HStack {
                    Text(peripheral.name)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
//                    print(peripheral.rssi)
                    BTManager.writeOutgoingValue(data: "Hello World")
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

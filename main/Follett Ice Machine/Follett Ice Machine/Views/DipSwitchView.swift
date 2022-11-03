//
//  DipSwitchView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 11/1/22.
//

import SwiftUI

struct DipSwitchView: View {
    
    @ObservedObject var BTManager: BLEManager
    
    @ObservedObject var dipSwitch = DipSwitchStatus.dswitch

    var body: some View {
        VStack{
            VStack {
                Text("Dip Switches")
                .font(.title)
            }
            
            HStack{
                VStack(alignment: .leading) {
                    Text("Switch #1").font(.system(size: 22, weight: .semibold)).lineLimit(2)
                    HStack {
                        if dipSwitch.isOn[0] {
                            Text("On")
                        } else {
                            Text("Off")
                        }
                        Spacer()
                        Toggle("", isOn: $dipSwitch.isOn[0]).disabled(true)
                    }
                }
                .frame(width: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(self.dipSwitch.isOn[0] ? Color.green: Color.gray, lineWidth: 2)
                )
                
                VStack(alignment: .leading) {
                    Text("Switch #2").font(.system(size: 22, weight: .semibold)).lineLimit(2)
                    HStack {
                        if self.dipSwitch.isOn[1] {
                            Text("On")
                        } else {
                            Text("Off")
                        }
                        Spacer()
                        Toggle("", isOn: $dipSwitch.isOn[1]).disabled(true)
                    }
                }
                .frame(width: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(self.dipSwitch.isOn[1] ? Color.green: Color.gray, lineWidth: 2)
                )
            }
            
            
            HStack{
                VStack(alignment: .leading) {
                    Text("Switch #3").font(.system(size: 22, weight: .semibold)).lineLimit(2)
                    HStack {
                        if self.dipSwitch.isOn[2] {
                            Text("On")
                        } else {
                            Text("Off")
                        }
                        Spacer()
                        Toggle("", isOn: $dipSwitch.isOn[2]).disabled(true)
                    }
                }
                .frame(width: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(self.dipSwitch.isOn[2] ? Color.green: Color.gray, lineWidth: 2)
                )
                
                VStack(alignment: .leading) {
                    Text("Switch #4").font(.system(size: 22, weight: .semibold)).lineLimit(2)
                    HStack {
                        if self.dipSwitch.isOn[3] {
                            Text("On")
                        } else {
                            Text("Off")
                        }
                        Spacer()
                        Toggle("", isOn: $dipSwitch.isOn[3]).disabled(true)
                    }
                }
                .frame(width: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(self.dipSwitch.isOn[3] ? Color.green: Color.gray, lineWidth: 2)
                )
            }
            
            HStack{
                VStack(alignment: .leading) {
                    Text("Switch #5").font(.system(size: 22, weight: .semibold)).lineLimit(2)
                    HStack {
                        if self.dipSwitch.isOn[4] {
                            Text("On")
                        } else {
                            Text("Off")
                        }
                        Spacer()
                        Toggle("", isOn: $dipSwitch.isOn[4]).disabled(true)
                    }
                }
                .frame(width: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(self.dipSwitch.isOn[4] ? Color.green: Color.gray, lineWidth: 2)
                )
                
                VStack(alignment: .leading) {
                    Text("Switch #6").font(.system(size: 22, weight: .semibold)).lineLimit(2)
                    HStack {
                        if self.dipSwitch.isOn[5] {
                            Text("On")
                        } else {
                            Text("Off")
                        }
                        Spacer()
                        Toggle("", isOn: $dipSwitch.isOn[5]).disabled(true)
                    }
                }
                .frame(width: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(self.dipSwitch.isOn[5] ? Color.green: Color.gray, lineWidth: 2)
                )
            }
            
            HStack{
                VStack(alignment: .leading) {
                    Text("Switch #7").font(.system(size: 22, weight: .semibold)).lineLimit(2)
                    HStack {
                        if self.dipSwitch.isOn[6] {
                            Text("On")
                        } else {
                            Text("Off")
                        }
                        Spacer()
                        Toggle("", isOn: $dipSwitch.isOn[6]).disabled(true)
                    }
                }
                .frame(width: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(self.dipSwitch.isOn[6] ? Color.green: Color.gray, lineWidth: 2)
                )
                
                VStack(alignment: .leading) {
                    Text("Switch #8").font(.system(size: 22, weight: .semibold)).lineLimit(2)
                    HStack {
                        if self.dipSwitch.isOn[7] {
                            Text("On")
                        } else {
                            Text("Off")
                        }
                        Spacer()
                        Toggle("", isOn: $dipSwitch.isOn[7]).disabled(true)
                    }
                }
                .frame(width: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(self.dipSwitch.isOn[7] ? Color.green: Color.gray, lineWidth: 2)
                )
            }
        }
    }
    
}

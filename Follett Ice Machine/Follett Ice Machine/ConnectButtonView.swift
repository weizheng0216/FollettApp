////
////  ConnectButtonView.swift
////  Follett Ice Machine
////
////  Created by Wei Zheng on 4/27/22.
////
//
//import SwiftUI
//
//struct ConnectButtonView: View {
//    @ObservedObject var viewModel: StatusLightViewModel
//    
//    var body: some View {
//        HStack {
//            if viewModel.connected {
//                Button(action: {
//                    viewModel.disconnectCalculator()
//                }, label: {
//                    Text("Disconnect")
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                }).buttonStyle(ConnectButton())
//            } else {
//                Button(action: {
//                    viewModel.connectCalculator()
//                }, label: {
//                    Text("Connect")
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                }).buttonStyle(ConnectButton())
//            }
//        }
//        .frame(width: 220)
//        .padding(.top)
//    }
//}
//
//struct ConnectButtonView_Previews: PreviewProvider {
//    static var viewModel = StatusLightViewModel()
//    static var previews: some View {
//        ConnectButtonView(viewModel: viewModel)
//    }
//}

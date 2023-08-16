//
//  AppMenu.swift
//  Battery
//
//  Created by leetao on 2023/8/14.
//

import SwiftUI


struct AppMenu: View {
    @State private var selected = false
    @ObservedObject private var viewModel:BatteryViewModel
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    init(viewModel:BatteryViewModel=BatteryViewModel()) {
        self.viewModel = viewModel
    }
    
     
    func enableBatteryLimit() {}
    func disableBatteryLimit() {}
    func exitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    
    var body: some View {
        VStack{
            Button(){
                selected.toggle()
                viewModel.refreshBatteryInfo()
                enableBatteryLimit()
            }label: {
                Text( selected ? "✓ Enable 80% battery limit":"Enable 80% battery limit")
            }.keyboardShortcut("E")
            Button(){
                selected.toggle()
                viewModel.refreshBatteryInfo()
                disableBatteryLimit()
            }label: {
                Text( !selected ? "✓ Disable 80% battery limit":"Disable 80% battery limit")
            }.keyboardShortcut("D")
            Divider()
            BatteryInfo(infos:$viewModel.data)
            Divider()
            Button(action: exitApp, label: { Text("Exit Battery") }).keyboardShortcut("Q")
        }.onReceive(timer) { _ in
                print("timer")
                viewModel.refreshBatteryInfo()
        }
        
    }
}




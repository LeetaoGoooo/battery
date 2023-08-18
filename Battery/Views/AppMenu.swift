//
//  AppMenu.swift
//  Battery
//
//  Created by leetao on 2023/8/14.
//

import SwiftUI


struct AppMenu: View {
    @State private var selected = false
    @Binding var electricity: String
    @Binding var supply: String
    @Binding var charging: Bool
    @Binding var errorRaise: Bool
    @Binding var errorMsg: String
    @Binding var is_limiter_enabled: Bool
    var enable_battery_limit:() -> Void
    var disable_battery_limit:() -> Void
    

    func exitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    
    var body: some View {
        Button(){
            enable_battery_limit()
        }label: {
            Text( is_limiter_enabled ? "✓ Enable 80% battery limit":"Enable 80% battery limit")
        }.keyboardShortcut("E")
        Button(){
            enable_battery_limit()
        }label: {
            Text( !is_limiter_enabled ? "✓ Disable 80% battery limit":"Disable 80% battery limit")
        }.keyboardShortcut("D")
        Divider()
        
        VStack{
            if (!errorRaise)  {
                Text("Electricity " + electricity)
                Text("Power Supply " + supply)
                Text("Charging " +  (charging ? "Yes":"No"))
            }    else {
                    Text(errorMsg)
                }
        }
        Divider()
        Button(action: exitApp, label: { Text("Exit Battery") }).keyboardShortcut("Q")
        
        
    }
}




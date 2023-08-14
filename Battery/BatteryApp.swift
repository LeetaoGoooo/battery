//
//  BatteryApp.swift
//  Battery
//
//  Created by leetao on 2023/8/13.
//

import SwiftUI

@main
struct BatteryApp: App {
    
    
    var body: some Scene {
        MenuBarExtra("Battery", systemImage: "battery.100") {
            AppMenu()
        }
    }
}

//
//  BatteryApp.swift
//  Battery
//
//  Created by leetao on 2023/8/13.
//

import SwiftUI

@main
struct BatteryApp: App {
    @State private var  systemImage = "battery.100"
    @State private var isInserted = true
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    func get_battery_percentage() -> String {
        do {
                let info = try Api.get_battery_info()
                if (info.contains("false")) {
                    return "battery.100.bolt"
                }
                let pattern = "(\\d+)%"
                let regex = try! NSRegularExpression(pattern: pattern)
                if let match = regex.firstMatch(in: info, range: NSRange(info.startIndex..., in: info)) {
                let level = info[Range(match.range, in: info)!]
                let batteryLevel =  Int(level[level.startIndex..<level.index(before: level.endIndex)])
                if (batteryLevel == nil || batteryLevel == 100){
                    return "battery.100"
                } else if (batteryLevel! >= 75) {
                    return "battery.75"
                } else if (batteryLevel! >= 50) {
                    return "battery.50"
                } else if (batteryLevel! >= 25) {
                    return "battery.25"
                }
                return "battery.0"
                    
            }
        } catch {
            print(error)
        }
        return "battery.100"
    }
    
    var body: some Scene {
        MenuBarExtra(isInserted: $isInserted) {
            AppMenu()
        } label: {
            let image = NSImage(systemSymbolName: systemImage, accessibilityDescription: nil)
            Image(nsImage: image!).onReceive(timer) {_ in
                systemImage = get_battery_percentage()
            }.onAppear{
                systemImage = get_battery_percentage()
            }
        }
    }
}


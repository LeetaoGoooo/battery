//
//  BatteryViewModel.swift
//  Battery
//
//  Created by leetao on 2023/8/16.
//

import Foundation

class BatteryViewModel: ObservableObject {
    @Published var data: [String] = []
    @Published var systemImage: String = "battery.100" // 图标
    @Published var electricity: String = "100%" // 电量
    @Published var supply: String = "AC Power" // 电源
    @Published var charging: Bool = true // 实际是否在充电
    @Published var errorRaise: Bool = false // 是否产生错误
    @Published var errorMsg: String = "Some Error occured"
    
    init() {
        refreshBatteryInfo()
    }
    
    func refreshBatteryInfo() {
        do {
            let info = try Api.get_battery_info()
            config_battery_view(info:info)
            errorRaise = false
        } catch {
            errorRaise = true
            errorMsg = error.localizedDescription
        }
    }
    
    func config_battery_view(info:String){
        if (info.contains("Battery Power")) {
            supply = "Battery Power"
        }
        if (info.contains("not charging present: true")) {
            charging = false
        }
        if (info.contains("AC attached")) {
            systemImage =  "battery.100.bolt"
            return
        }
        let pattern = "(\\d+)%"
        let regex = try! NSRegularExpression(pattern: pattern)
        if let match = regex.firstMatch(in: info, range: NSRange(info.startIndex..., in: info)) {
        let level = info[Range(match.range, in: info)!]
        electricity = String(level)

        let batteryLevel =  Int(level[level.startIndex..<level.index(before: level.endIndex)])
        
        if (batteryLevel == nil || batteryLevel == 100){
            systemImage =  "battery.100"
        } else if (batteryLevel! >= 75) {
            systemImage =  "battery.75"
        } else if (batteryLevel! >= 50) {
            systemImage = "battery.50"
        } else if (batteryLevel! >= 25) {
            systemImage =  "battery.25"
        }
            systemImage =  "battery.0"
        }
    }
}

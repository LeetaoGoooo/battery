//
//  BatteryViewModel.swift
//  Battery
//
//  Created by leetao on 2023/8/16.
//

import Foundation

class BatteryViewModel: ObservableObject {
    @Published var systemImage: String = "battery.100" // 图标
    @Published var electricity: String = "100%" // 电量
    @Published var supply: String = "AC Power" // 电源
    @Published var charging: Bool = true // 实际是否在充电
    @Published var errorRaise: Bool = false // 是否产生错误
    @Published var errorMsg: String = "Some Error occured"
    @Published var is_limiter_enabled: Bool = false // 是否开启了限制
    let api = Api()
    
    init() {
        refreshBatteryInfo()
    }
    
    func refreshBatteryInfo() {
        do {
            let info = try Api.get_battery_info()
            config_battery_view(info:info)
            is_limiter_enabled = Api.is_limiter_enabled()
            errorRaise = false
        } catch {
            errorRaise = true
            errorMsg = error.localizedDescription
        }
    }
    
    func config_battery_view(info:String){
        
        if (info.contains("Battery Power")) {
            supply = "Battery Power"
        } else {
            supply = "AC Power"
        }
        if (info.contains("true")) {
            charging = false
        } else {
            charging = true
        }
        
        let pattern = "(\\d+)%"
        let regex = try! NSRegularExpression(pattern: pattern)
        if let match = regex.firstMatch(in: info, range: NSRange(info.startIndex..., in: info)) {
            let level = info[Range(match.range, in: info)!]
            electricity = String(level)
            
            let batteryLevel =  Int(level[level.startIndex..<level.index(before: level.endIndex)])
            let status = charging ? "active" : "inactive"
            
            if (batteryLevel == nil) {
                systemImage = "battery-\(status)-100-Template"
                
            } else {
                let remainder = batteryLevel! % 5
                let res = batteryLevel! / 5 + (remainder > 0 ? 1:0)
                let level = res * 5
                systemImage = "battery-\(status)-\(level)-Template"
            }
        }
    }
        
    func enable_battery_limit() {
        api.enable_battery_limiter()
        refreshBatteryInfo()
    }
    
    func disable_battery_limit() {
        api.disable_battery_limiter()
        refreshBatteryInfo()
    }
}

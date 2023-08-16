//
//  Api.swift
//  Battery
//
//  Created by leetao on 2023/8/13.
//
import Foundation



class Api {
    let resourceName = "smc"
    let task = Process()
    let pipe = Pipe()
    
    
    init() {
        if let resourcePath = Bundle.main.path(forResource: resourceName, ofType:  nil) {
            task.launchPath = resourcePath
            task.standardOutput = pipe
            task.standardError = pipe
        } else {
            print("not found resourcePath")
        }
     
    }


    // root
    func enable_discharging() -> Bool {
        task.arguments = ["-k", "CH0I", "-w", "01"]
        do {
            try task.run()
        } catch {
            return false
        }
        return true
    }
    
    // root
    func disable_discharging() -> Bool {
        task.arguments = ["-k", "CH0I", "-w", "00"]
        do {
            try task.run()
        } catch {
            return false
        }
        return true
    }
    
    
    // root
    func enable_charging() -> Bool {
        task.arguments = ["-k", "CH0B", "-w", "00"]
        do {
            try task.run()
            task.arguments = ["-k", "CH0C", "-w", "00"]
            try task.run()
            return self.disable_discharging()
        } catch {
            return false
        }
    }
    
    // root
    func disable_charging() -> Bool {
        task.arguments = ["-k", "CH0B", "-w", "02"]
        do {
            try task.run()
            task.arguments = ["-k", "CH0C", "-w", "02"]
            try task.run()
        } catch {
            return false
        }
        return true
    }
    
    func get_sms_charging_status() throws -> Bool {
        task.arguments =  ["-k", "CH0B", "-r", "|", "awk", "'{print $4}'", "|", "sed", "s:\\)::"]
        try task.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data:data, encoding: .utf8)
        return output == "00"
        
    }
    
    func get_smc_discharging_status() throws -> Bool {
        task.arguments =  ["-k", "CH0I", "-r", "|", "awk", "'{print $4}'", "|", "sed", "s:\\)::"]
        try task.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data:data, encoding: .utf8)
        return output == "0"
    }
    
    static func get_battery_info() throws -> String {
        let batteryTask = Process()
        batteryTask.launchPath = "/usr/bin/pmset"
        batteryTask.arguments = ["-g","batt"]
        let batteryPipe = Pipe()
        batteryTask.standardOutput = batteryPipe
        batteryTask.standardError = batteryPipe
        try batteryTask.run()
        let data = batteryPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data:data, encoding: .utf8)
        if (output != nil) {
            return output!
        }
        return "Try to restart App"
    }
    
}

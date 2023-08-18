//
//  Api.swift
//  Battery
//
//  Created by leetao on 2023/8/13.
//
import Foundation
import os
import Reachability
import AppKit


class Api {
    
    let logger = Logger()
    let reachability = try! Reachability()
    let user:String
    let home:String
    
    func showAlert(title:String, msg:String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = msg
        alert.runModal()
    }
    
    func exec_command_without_sudo(_ args: String..., onlyBash:Bool = false) -> String? {
        logger.info("Executing \(args)")
        let task = Process()
        if (onlyBash) {
            task.environment = ["HOME":home, "PATH":"/usr/local/bin", "USER":user]
            task.launchPath = "/usr/bin/env"
            task.arguments = args
        } else {
            task.environment = ["PATH":"/bin:/usr/bin:/usr/local/bin:/usr/sbin:/opt/homebrew","HOME":home, "USER":user]
            task.launchPath = "/usr/bin/env"
            task.arguments = args
        }
       
        
        let pipe = Pipe()
        task.standardOutput = pipe
        do {
            try task.run()
            
            let data =  pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)
            
            if (output != nil) {
                if (output!.isEmpty) {
                    return nil
                }
                logger.info("output:\(output!)")
                return output!
            }
            
        } catch {
            return nil
        }
        return nil
    }
    
    func exec_sudo_command(command:String) -> Bool{
        logger.info("Executing  \(command)")
        logger.info("do shell script \"\(command)\" with administrator privileges")
        let process = Process()
        process.launchPath = "/usr/bin/osascript"
        process.arguments = ["-e", "do shell script \"\(command)\" with administrator privileges"]
        process.launch()
        process.waitUntilExit()
        let battery_installed = exec_command_without_sudo("which", "battery")?.contains("not found") ?? false
        let smc_installed = exec_command_without_sudo("which","smc")?.contains("not found") ?? false
        return battery_installed && smc_installed
    }
    
    init() {
        user = ProcessInfo.processInfo.environment["USER"]!
        home = ProcessInfo.processInfo.environment["HOME"]!
        init_battery()
    }
    
    func init_battery() {
        let battery_installed = exec_command_without_sudo("which", "battery")?.contains("battery") ?? false
        let smc_installed = exec_command_without_sudo("which","smc")?.contains("smc") ?? false
        
        let charging_in_visudo = exec_command_without_sudo("sudo","-n","/usr/local/bin/smc", "-k", "CH0C", "-r")?.contains("CH0C") ?? false
        let discharging_in_visudo = exec_command_without_sudo("sudo","-n","/usr/local/bin/smc", "-k","CH0I", "-r")?.contains("CH0I") ?? false
        let visudo_complete = charging_in_visudo && discharging_in_visudo
        let is_installed = battery_installed && smc_installed
    
        logger.info("Is installed? \(is_installed) visudo_complete: \(visudo_complete) ")
        
         _ = exec_command_without_sudo("pkill", "-f","/usr/local/bin/battery.*")
    
        
        if (!is_installed || !visudo_complete) {
            logger.info(" Installing battery for USER")
            if (reachability.connection == .unavailable) {
                showAlert(title: "Warning", msg:"You Lost NetWork!")
                return
            } else {
                let result = exec_sudo_command(command: "curl -s https://raw.githubusercontent.com/actuallymentor/battery/main/setup.sh | bash -s -- \(user)")
                logger.info("Install Result: \(result)")
                if (result) {
                    showAlert(title: "Info", msg: "Battery background components installed successfully. You can find the battery limiter icon in the top right of your menu bar")
                } else {
                    showAlert(title: "Warning", msg: "Battery background components installed failed. You can excute this command `curl -s https://raw.githubusercontent.com/actuallymentor/battery/main/setup.sh | bash -s -- \(user)` on shell by yourself")
                }
      
            }
        }
        _ = exec_command_without_sudo("/usr/local/bin/battery","maintain","recover",onlyBash: true)
    }
    
    func enable_battery_limiter() {
        let _ = exec_command_without_sudo("/usr/local/bin/battery","maintain", "80",onlyBash: true)
    }
    

    func disable_battery_limiter() {
        let _ =   exec_command_without_sudo("/usr/local/bin/battery","maintain", "stop",onlyBash: true)
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
    
    func is_limiter_enabled() -> Bool {
        let task = Process()
        task.environment = ["HOME":home,"USER":user]
        task.launchPath = "/usr/local/bin/battery"
        task.arguments = ["status"]
        let pipe = Pipe()
        task.standardOutput = pipe
        do {
            try task.run()
            let data =  pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)
            logger.info("output:\(output!)")
            if (output != nil) {
                if (output!.isEmpty) {
                    return false
                }
                return output!.contains("smc charging disabled")
            }
            
        } catch {
            return false
        }
        return false
    }
    
}

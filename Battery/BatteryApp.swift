//
//  BatteryApp.swift
//  Battery
//
//  Created by leetao on 2023/8/13.
//

import SwiftUI
import AppKit

@main
struct BatteryApp: App {
    @State private var isInserted = true
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @ObservedObject private var viewModel:BatteryViewModel = BatteryViewModel()
    
    var body: some Scene {
        MenuBarExtra(isInserted: $isInserted) {
            AppMenu(electricity: $viewModel.electricity, supply: $viewModel.supply, charging:$viewModel.charging, errorRaise:$viewModel.errorRaise, errorMsg: $viewModel.errorMsg,
                    is_limiter_enabled:$viewModel.is_limiter_enabled,
                    enable_battery_limit: viewModel.enable_battery_limit,disable_battery_limit:  viewModel.disable_battery_limit
            )
        } label: {
            Image(viewModel.systemImage).renderingMode(.template).onReceive(timer) {_ in
                viewModel.refreshBatteryInfo()
            }
        }
    }
}


//
//  BatteryInfo.swift
//  Battery
//
//  Created by leetao on 2023/8/16.
//

import SwiftUI

struct BatteryInfo: View {
    @Binding var infos:[String]
    
    var body: some View {
        ForEach(infos, id: \.self) { info in
              Text(info)
        }
    }
}


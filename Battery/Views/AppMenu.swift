//
//  AppMenu.swift
//  Battery
//
//  Created by leetao on 2023/8/14.
//

import SwiftUI

struct AppMenu: View {
     @State var selected = false;
    
    func action1() {}
    func action2() {}
    func exitApp() {
        NSApplication.shared.terminate(nil)
    }

    var body: some View {
        Button(){
            selected.toggle()
        }label: {
            Text( selected ? "✓ Enable 80% battery limit":"Enable 80% battery limit")
        }.keyboardShortcut("E")
        Button(){
            selected.toggle()
        }label: {
            Text( !selected ? "✓ Disable 80% battery limit":"Disable 80% battery limit")
        }.keyboardShortcut("D")
        Divider()
        // TODO txt
        Divider()
        Button(action: exitApp, label: { Text("退出 Battery") }).keyboardShortcut("Q")
    }
}

struct AppMenu_Previews: PreviewProvider {
    static var previews: some View {
        AppMenu()
    }
}




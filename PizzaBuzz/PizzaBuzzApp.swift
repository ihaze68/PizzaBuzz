//
//  PizzaBuzzApp.swift
//  PizzaBuzz
//
//  Created by HaZe on 06/10/2022.
//

import SwiftUI

let greenColor = Color(uiColor: UIColor(red: 20/255, green: 158/255, blue: 20/255, alpha: 0.95))
let lightGreenColor = Color(uiColor: UIColor(red: 220/255, green: 250/255, blue: 220/255, alpha: 0.95))
let grayColor = Color(uiColor: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1))

@main
struct PizzaBuzzApp: App {
    var body: some Scene {
        WindowGroup {
            MenuView(data:DataService())
        }
    }
}

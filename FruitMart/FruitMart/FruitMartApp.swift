//
//  FruitMartApp.swift
//  FruitMart
//
//  Created by gaeng on 2022/09/14.
//

import SwiftUI

@main
struct FruitMartApp: App {
    var body: some Scene {
        WindowGroup {
            Home(store: Store())
        }
    }
}

//
//  TestAppApp.swift
//  TestApp
//
//  Created by Artyom Arzumanyan on 24.04.25.
//

import SwiftUI

@main
struct TestTaskApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    init() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        UITabBar.appearance().backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(networkMonitor) 
        }
    }
}


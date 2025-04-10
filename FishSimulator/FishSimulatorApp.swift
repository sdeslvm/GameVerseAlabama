//
//  FishSimulatorApp.swift
//  FishSimulator
//
//  Created by Pavel Ivanov on 25.03.2025.
//

import SwiftUI

@main
struct FishSimulatorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LoadScreen()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if CurrentStorage.shared.isGreetingShowing {
            return .allButUpsideDown
        } else {
            return .landscape
        }
    }
}

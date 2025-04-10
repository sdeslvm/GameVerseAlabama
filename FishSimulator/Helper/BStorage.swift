//
//  BackgroundStorage.swift
//  FishSimulator
//
//  Created by Pavel Ivanov on 26.03.2025.
//

import Foundation

class BStorage {
    static let shared = BStorage()
    
    private let pchKey = "purchased_backgrounds"
    private let currentKey = "selected_background"
    
    private let defaults = UserDefaults.standard
    
    private let defaultBackground = "river_day"
    
    private init() {
        // Установить фон по умолчанию, если запускается впервые
        if defaults.string(forKey: currentKey) == nil {
            defaults.set(defaultBackground, forKey: currentKey)
        }
        if defaults.array(forKey: pchKey) == nil {
            defaults.set([defaultBackground], forKey: pchKey)
        }
    }
    
    var purchasedBackgrounds: [String] {
        defaults.stringArray(forKey: pchKey) ?? [defaultBackground]
    }
    
    var selectedBackground: String {
        defaults.string(forKey: currentKey) ?? defaultBackground
    }
    
    func selectBackground(named name: String) {
        guard purchasedBackgrounds.contains(name) else { return }
        defaults.set(name, forKey: currentKey)
    }
    
    func purchaseBackground(named name: String) {
        var purchased = purchasedBackgrounds
        guard !purchased.contains(name) else { return }
        purchased.append(name)
        defaults.set(purchased, forKey: pchKey)
    }
    
    func isAvailable(name: String) -> Bool {
        purchasedBackgrounds.contains(name)
    }
}

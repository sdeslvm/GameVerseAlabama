//
//  FishermanStorage.swift
//  FishSimulator
//
//  Created by Pavel Ivanov on 26.03.2025.
//

import Foundation

class CurrentStorage {
    static let shared = CurrentStorage()
    
    private let currentItems = "purchased_fishermans"
    private let selectedItems = "selected_fisherman"
    var isGreetingShowing: Bool = false
    
    private let defaults = UserDefaults.standard
    
    private let defaultFisherman = "fisherman_default"
    
    private init() {
        // Установить фон по умолчанию, если запускается впервые
        if defaults.string(forKey: selectedItems) == nil {
            defaults.set(defaultFisherman, forKey: selectedItems)
        }
        if defaults.array(forKey: currentItems) == nil {
            defaults.set([defaultFisherman], forKey: currentItems)
        }
    }
    
    var availableSkins: [String] {
        defaults.stringArray(forKey: currentItems) ?? [defaultFisherman]
    }
    
    var selectedSkin: String {
        defaults.string(forKey: selectedItems) ?? defaultFisherman
    }
    
    func selectSkin(named name: String) {
        guard availableSkins.contains(name) else { return }
        defaults.set(name, forKey: selectedItems)
    }
    
    func getSkin(named name: String) {
        var purchased = availableSkins
        guard !purchased.contains(name) else { return }
        purchased.append(name)
        defaults.set(purchased, forKey: currentItems)
    }
    
    func isAvailable(name: String) -> Bool {
        availableSkins.contains(name)
    }
}

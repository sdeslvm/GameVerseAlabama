//
//  Settings.swift
//  FishSimulator
//
//  Created by Pavel Ivanov on 25.03.2025.
//

import SwiftUI

struct SettingsScreen: View {
    var onBack: () -> Void
    
    @State var isSoundEnabled = true
//    @State var language: Language = .english
    
    var body: some View {
        ZStack {
            CurrentBackground()
            VStack {
                CustomNavigation(text: "SETTINGS", coins: 3454) {
                    onBack()
                }
                Spacer()
                VStack(spacing: 20) {
                    StrokedText(text: "Sounds", size: 32)
                    HStack(spacing: 44) {
                        ActiveWoodenButton(text: "on", isActive: isSoundEnabled) {
                            isSoundEnabled = true
                            SoundManager.shared.isSoundOn = true
                        }
                        ActiveWoodenButton(text: "off", isActive: !isSoundEnabled) {
                            isSoundEnabled = false
                            SoundManager.shared.isSoundOn = false
                        }
                    }
                }.padding()
//                VStack(spacing: 20) {
//                    StrokedText(text: "Language", size: 32)
//                    HStack(spacing: 24) {
//                        ActiveWoodenButton(text: "English", isActive: language == .english) {
//                            language = .english
//                        }
//                        ActiveWoodenButton(text: "Spanish", isActive: language == .spanish) {
//                            language = .spanish
//                        }
//                        ActiveWoodenButton(text: "French", isActive: language == .french ) {
//                            language = .french
//                        }
//                        ActiveWoodenButton(text: "Italian", isActive: language == .italian) {
//                            language = .italian
//                        }
//                    }
//                }.padding()
            }
        }
    }
}

//enum Language {
//    case english
//    case french
//    case spanish
//    case italian
//}

struct ActiveWoodenButton: View {
    var text: String
    var isActive: Bool
    var onTap: () -> Void
    
    var body: some View {
        WoodenButton(text: text, size: 20) { onTap() }
            .colorMultiply(isActive ? .white : .gray)
            .frame(width: 110, height: 28)
    }
}

#Preview {
    SettingsScreen {
        //
    }
}

//
//  GameElement.swift
//  FishSimulator
//
//  Created by alex on 3/28/25.
//

import Foundation
import SwiftUI
struct GameElement: View {
    
    let itemType: ElementType
    let text: String
    let price: String
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                switch itemType {
                case .depth:
                    Assets.UI.depthCountFrame
                        .frame(width: 140, height: 80)
                case .fish:
                    Assets.UI.fishCountFrame
                        .frame(width: 140, height: 80)
                }
                StrokedText(text: text, size: 28, strokeColor: .red)
                    .offset(x: 15, y: -2)
            }
            WoodenButton(text: price, size: 20) {
                onTap()
            }
            .frame(width: 100, height: 32)
        }
    }
}

enum ElementType {
    case depth
    case fish
}

//
//  UIElements.swift
//  FishSimulator
//
//  Created by Pavel Ivanov on 25.03.2025.
//

import SwiftUI

struct CurrentBackground: View {
    var body: some View {
        GeometryReader { geo in
            Assets.Backgtounds.getCurrent()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
        }.ignoresSafeArea()
    }
}

struct CurrentPlayer: View {
    var body: some View {
        GeometryReader { geo in
            Assets.Fishermans.getCurrent()
                .frame(width: geo.size.width * 0.48, height: geo.size.height * 0.7)
                .offset(x: geo.size.width * 0.05, y: geo.size.height * 0.25)
        }.ignoresSafeArea()
    }
}

struct WoodenButton: View {
    var text: String
    var size: CGFloat
    var onTap: () -> Void
    
    init(text: String, size: CGFloat = 36, onTap: @escaping () -> Void) {
        self.text = text
        self.size = size
        self.onTap = onTap
    }
    
    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack {
                Assets.UI.woodenButton
                StrokedText(text: text, size: size)
            }
        }

    }
}

struct CoinFullItem: View {
    var text: String
    
    var body: some View {
        ZStack {
            Assets.UI.coinsFull
                .frame(width: 180, height: 44)
            StrokedText(text: text, size: 20)
                .offset(x: 18, y: 2)
        }
    }
}

struct CustomNavigation: View {
    var text: String
    var coins: Int
    var onBack: () -> Void
    var needToShowCoins: Bool
    
    init(text: String, coins: Int, needToShowCoins: Bool = false, onBack: @escaping () -> Void) {
        self.text = text
        self.coins = coins
        self.onBack = onBack
        self.needToShowCoins = needToShowCoins
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            StrokedText(text: text ,size: 64)
            HStack(alignment: .bottom) {
                Button {
                    onBack()
                } label: {
                    Assets.UI.backButton
                        .frame(width: 60, height: 60)
                }
                Spacer()
                if needToShowCoins {
                    CoinFullItem(text: "\(coins)")
                }
            }
        }.padding()
            .padding(.top)
    }
}

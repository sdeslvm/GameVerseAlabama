import SwiftUI

struct FinalView: View {
    
    var fishCount: Int
    var coinsCount: Int
    var onRestart: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        ZStack {
            Assets.UI.winSublayer
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                StrokedText(text: "YOU WIN", size: 84, strokeColor: .white, textColor: .red)
                    .padding(.top)
                StrokedText(text: "You caught \(fishCount) fish!", size: 24, strokeColor: .red, textColor: .white)
                HStack {
                    StrokedText(text: "+\(fishCount)", size: 56, strokeColor: .white, textColor: .red)
                    Assets.UI.catchedFish
                        .frame(width: 52, height: 48)
                        .offset(y: -4)
                }.padding(.top)
                Spacer()
                CoinFullItem(text: "+\(coinsCount)")
                HStack(spacing: 16) {
                    Button {
                        onBack()
                    } label: {
                        Assets.UI.optionsButton
                            .frame(width: 80, height: 80)
                    }
                    Button {
                        onRestart()
                    } label: {
                        Assets.UI.restartButton
                            .frame(width: 80, height: 80)
                    }
                }.padding(.top, 8)
            }.padding()
        }
    }
}

#Preview {
    FinalView(fishCount: 56, coinsCount: 1302) { } onBack: { }
}


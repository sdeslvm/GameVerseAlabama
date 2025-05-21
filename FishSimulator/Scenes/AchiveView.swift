import SwiftUI

struct AchiveView: View {

    @State private var selectedAchive: String? = nil
    var onBack: () -> Void
    @AppStorage("coins") private var coins: Int = 0
    @AppStorage("stars") private var stars: Int = 0

    @State private var showInsufficientFundsModal: Bool = false
    @State private var insufficientCurrencyMessage: String = ""

    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                
                ZStack {
                    VStack {
                        HStack(spacing: 100) {
                            Button(action: { selectedAchive = "achive1" }) {
                                Image(.achive1)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            }
                            
                            Button(action: { selectedAchive = "achive3" }) {
                                Image(.achive3)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            }
                            
                            Button(action: { selectedAchive = "achive5" }) {
                                Image(.achive5)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            }
                        }
                        HStack(spacing: 100) {
                            Button(action: { selectedAchive = "achive2" }) {
                                Image(.achive2)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            }
                            
                            Button(action: { selectedAchive = "achive4" }) {
                                Image(.achive4)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            }
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .background(
                    Image("backgroundAchive")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .scaleEffect(1.1)
                )
                
                // Conditional modal view overlay
                if let achiveName = selectedAchive {
                    ZStack {
                        Color.black.opacity(0.6)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture { selectedAchive = nil } // Dismiss modal by tapping outside

                        // Display the correct modal based on selectedAchive
                        Group {
                            if achiveName == "achive1" { achive1View(coins: $coins, stars: $stars, showInsufficientFundsModal: $showInsufficientFundsModal, insufficientCurrencyMessage: $insufficientCurrencyMessage, onDismiss: { selectedAchive = nil }) }
                            else if achiveName == "achive2" { achive2View(coins: $coins, stars: $stars, showInsufficientFundsModal: $showInsufficientFundsModal, insufficientCurrencyMessage: $insufficientCurrencyMessage, onDismiss: { selectedAchive = nil }) }
                            else if achiveName == "achive3" { achive3View(coins: $coins, stars: $stars, showInsufficientFundsModal: $showInsufficientFundsModal, insufficientCurrencyMessage: $insufficientCurrencyMessage, onDismiss: { selectedAchive = nil }) }
                            else if achiveName == "achive4" { achive4View(coins: $coins, stars: $stars, showInsufficientFundsModal: $showInsufficientFundsModal, insufficientCurrencyMessage: $insufficientCurrencyMessage, onDismiss: { selectedAchive = nil }) }
                            else if achiveName == "achive5" { achive5View(coins: $coins, stars: $stars, showInsufficientFundsModal: $showInsufficientFundsModal, insufficientCurrencyMessage: $insufficientCurrencyMessage, onDismiss: { selectedAchive = nil }) }
                        }
                    }
                }
                
                VStack {
                    CustomNavigation(text: "", coins: 0) {
                        onBack()
                    }
                    .padding()
                    Spacer()
                }

                // Insufficient Funds Modal
                if showInsufficientFundsModal {
                    InsufficientFundsView(message: insufficientCurrencyMessage, onDismiss: { showInsufficientFundsModal = false })
                }
                
                
            }
        }
    }
}

#Preview {
    AchiveView {
        
    }
}

// MARK: - Achievement Modal Views (Placeholders)

struct achive1View: View {
    @Binding var coins: Int
    @Binding var stars: Int
    @Binding var showInsufficientFundsModal: Bool
    @Binding var insufficientCurrencyMessage: String
    var onDismiss: () -> Void
    var isPad = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.achive1View)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        ZStack {
                            Image(.upgradeBtn)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 220, height: 100)
                                .position(x: isPad ? 800 : 400, y: isPad ? 600 : 285)
                                .onTapGesture {
                                    let requiredCoins = 10
                                    let requiredStars = 5
                                    if coins >= requiredCoins && stars >= requiredStars {
                                        coins -= requiredCoins
                                        stars -= requiredStars
                                        onDismiss() // Dismiss on successful purchase
                                    } else {
                                        var message = "Insufficient Funds:\n"
                                        if coins < requiredCoins { message += "Need \(requiredCoins) Coins\n" }
                                        if stars < requiredStars { message += "Need \(requiredStars) Stars" }
                                        insufficientCurrencyMessage = message
                                        showInsufficientFundsModal = true
                                    }
                                }
                        }
                    )
                    .shadow(radius: 10)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct achive2View: View {
    @Binding var coins: Int
    @Binding var stars: Int
    @Binding var showInsufficientFundsModal: Bool
    @Binding var insufficientCurrencyMessage: String
    var onDismiss: () -> Void
    var isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        Image(.achive2View)
            .resizable()
            .scaledToFit()
            .overlay(
                ZStack {
                    Image(.upgradeBtn)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 100)
                        .position(x: isPad ? 800 : 400, y: isPad ? 600 : 285)
                        .onTapGesture {
                            let requiredCoins = 8
                            let requiredStars = 5
                            if coins >= requiredCoins && stars >= requiredStars {
                                coins -= requiredCoins
                                stars -= requiredStars
                                onDismiss()
                            } else {
                                var message = "Insufficient Funds:\n"
                                if coins < requiredCoins { message += "Need \(requiredCoins) Coins\n" }
                                if stars < requiredStars { message += "Need \(requiredStars) Stars" }
                                insufficientCurrencyMessage = message
                                showInsufficientFundsModal = true
                            }
                        }
                }
            )
            .shadow(radius: 10)
    }
}

struct achive3View: View {
    @Binding var coins: Int
    @Binding var stars: Int
    @Binding var showInsufficientFundsModal: Bool
    @Binding var insufficientCurrencyMessage: String
    var onDismiss: () -> Void
    var isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        Image(.achive3View)
            .resizable()
            .scaledToFit()
            .overlay(
                ZStack {
                    Image(.upgradeBtn)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 100)
                        .position(x: isPad ? 800 : 400, y: isPad ? 600 : 285)
                        .onTapGesture {
                            let requiredCoins = 10
                            let requiredStars = 8
                            if coins >= requiredCoins && stars >= requiredStars {
                                coins -= requiredCoins
                                stars -= requiredStars
                                onDismiss()
                            } else {
                                var message = "Insufficient Funds:\n"
                                if coins < requiredCoins { message += "Need \(requiredCoins) Coins\n" }
                                if stars < requiredStars { message += "Need \(requiredStars) Stars" }
                                insufficientCurrencyMessage = message
                                showInsufficientFundsModal = true
                            }
                        }
                }
            )
            .shadow(radius: 10)
    }
}

struct achive4View: View {
    @Binding var coins: Int
    @Binding var stars: Int
    @Binding var showInsufficientFundsModal: Bool
    @Binding var insufficientCurrencyMessage: String
    var onDismiss: () -> Void
    var isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        Image(.achive4View)
            .resizable()
            .scaledToFit()
            .overlay(
                ZStack {
                    Image(.upgradeBtn)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 100)
                        .position(x: isPad ? 800 : 400, y: isPad ? 600 : 285)
                        .onTapGesture {
                            let requiredCoins = 12
                            let requiredStars = 6
                            if coins >= requiredCoins && stars >= requiredStars {
                                coins -= requiredCoins
                                stars -= requiredStars
                                onDismiss()
                            } else {
                                var message = "Insufficient Funds:\n"
                                if coins < requiredCoins { message += "Need \(requiredCoins) Coins\n" }
                                if stars < requiredStars { message += "Need \(requiredStars) Stars" }
                                insufficientCurrencyMessage = message
                                showInsufficientFundsModal = true
                            }
                        }
                }
            )
            .shadow(radius: 10)
    }
}

struct achive5View: View {
    @Binding var coins: Int
    @Binding var stars: Int
    @Binding var showInsufficientFundsModal: Bool
    @Binding var insufficientCurrencyMessage: String
    var onDismiss: () -> Void
    var isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        Image(.achive5View)
            .resizable()
            .scaledToFit()
            .overlay(
                ZStack {
                    Image(.upgradeBtn)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 100)
                        .position(x: isPad ? 800 : 400, y: isPad ? 600 : 285)
                        .onTapGesture {
                            let requiredCoins = 8
                            let requiredStars = 5
                            if coins >= requiredCoins && stars >= requiredStars {
                                coins -= requiredCoins
                                stars -= requiredStars
                                onDismiss()
                            } else {
                                var message = "Insufficient Funds:\n"
                                if coins < requiredCoins { message += "Need \(requiredCoins) Coins\n" }
                                if stars < requiredStars { message += "Need \(requiredStars) Stars" }
                                insufficientCurrencyMessage = message
                                showInsufficientFundsModal = true
                            }
                        }
                }
            )
            .shadow(radius: 10)
    }
}

// MARK: - Insufficient Funds Modal View

struct InsufficientFundsView: View {
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: onDismiss)

            VStack(spacing: 20) {
                Text("Attention!")
                    .font(.custom("BULGOGI", size: 30))
                    .foregroundColor(.white)

                Text(message)
                    .font(.custom("BULGOGI", size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Button(action: onDismiss) {
                    Text("OK")
                        .font(.custom("BULGOGI", size: 20))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            .frame(width: 300)
            .background(Color(red: 0.4, green: 0.25, blue: 0.08))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}


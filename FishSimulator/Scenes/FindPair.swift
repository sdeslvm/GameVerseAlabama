import SwiftUI

// MARK: - Model
struct Card: Identifiable {
    let id: UUID = UUID()
    let content: String

    static func createPairs() -> [Card] {
        let contents = ["🐟", "🐠", "🐡", "🐬", "🐳", "🦈"]
        var cards: [Card] = []

        for content in contents {
            let pair = [Card(content: content), Card(content: content)]
            cards.append(contentsOf: pair)
        }

        return cards.shuffled()
    }
}

// MARK: - Card View
struct CardView: View {
    let card: Card
    let isFlipped: Bool

    // Mapping from old emoji content to new asset names
    private let assetMapping: [String: String] = [
        "🐟": "card1",
        "🐠": "card2",
        "🐡": "card3",
        "🐬": "card4",
        "🐳": "card5",
        "🦈": "card6"
    ]

    var body: some View {
        ZStack {
            if isFlipped {
                if let assetName = assetMapping[card.content] {
                    Image(assetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 90)
                        .cornerRadius(8)
                } else {
                    // Fallback or error handling if content doesn't map to an asset
                    Text(card.content)
                        .font(.largeTitle)
                        .frame(width: 60, height: 90)
                        .background(Color.white)
                        .cornerRadius(8)
                }
            } else {
                Image("backCard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
            }
        }
        .animation(.easeInOut, value: isFlipped)
    }
}

// MARK: - Modal View
struct ModalView: View {
    let title: String
    let message: String
    let buttonTitle: String
    let buttonColor: Color
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text(title)
                    .font(.custom("BULGOGI", size: 36))
                    .foregroundColor(.white)

                Text(message)
                    .font(.custom("BULGOGI", size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Button(action: onDismiss) {
                    Text(buttonTitle)
                        .font(.custom("BULGOGI", size: 24))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(buttonColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.9))
            .cornerRadius(20)
            .padding(.horizontal, 30)
        }
    }
}

// MARK: - Main Game View
struct FindPair: View {
    var onBack: () -> Void
    @State private var cards: [Card] = Card.createPairs()
    @State private var flippedIndices: [Int] = []
    @State private var matchedCards: Set<UUID> = []
    @State private var timeRemaining: Int = 45
    @State private var showWinModal = false
    @State private var showLoseModal = false
    @AppStorage("coins") private var coins: Int = 0
    @State private var timer: Timer?
    @State private var incorrectTries: Int = 0

    // State variables for controlling card spacing
    @State private var horizontalCardSpacing: CGFloat = 10 // Adjust as needed
    @State private var verticalCardSpacing: CGFloat = -30 // Adjust as needed

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Фон теперь применен как background к ZStack

                // Возможно, этот VStack с Spacer и miniGamePlate все еще влияет на макет
                
                VStack {
                     
                     Image(.miniGamePlate)
                         .resizable()
                         .scaledToFit()
                         .frame(width: 700)
                 }
                 
              
                // Объединяем навигацию и игровой контент в один VStack для лучшего контроля вертикального макета
                VStack {
                    CustomNavigation(text: "", coins: 0) {
                        onBack()
                    }
                    .padding()
                    Spacer()
                }
                
                
                
                VStack {
                    Text("Find a match")
                        .font(.custom("BULGOGI", size: 36))
                        .foregroundStyle(.white)

                    HStack {
                        Text("Tries: \(5 - incorrectTries)")
                            .font(.custom("BULGOGI", size: 24))
                            .foregroundStyle(.white)
                        Text("Time: \(timeRemaining)s")
                            .font(.custom("BULGOGI", size: 24))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                }
                .padding(.top, 70)

                // VStack, содержащий заголовок, таймер и LazyVGrid.
                // Устанавливаем spacing 0, чтобы убрать стандартные отступы между ними.
                

                    // Используем VStack с HStacks для явного контроля вертикального и горизонтального отступа
                    VStack(spacing: verticalCardSpacing) { // spacing для вертикального расстояния между строками
                        HStack(spacing: horizontalCardSpacing) { // spacing для горизонтального расстояния в первой строке
                            ForEach(0..<4) { index in
                                CardView(
                                    card: cards[index],
                                    isFlipped: flippedIndices.contains(index) || matchedCards.contains(cards[index].id)
                                )
                                .onTapGesture {
                                    flipCard(at: index)
                                }
                            }
                        }

                        HStack(spacing: horizontalCardSpacing) { // spacing для горизонтального расстояния во второй строке
                            ForEach(4..<8) { index in
                                CardView(
                                    card: cards[index],
                                    isFlipped: flippedIndices.contains(index) || matchedCards.contains(cards[index].id)
                                )
                                .onTapGesture {
                                    flipCard(at: index)
                                }
                            }
                        }

                        HStack(spacing: horizontalCardSpacing) { // spacing для горизонтального расстояния в третьей строке
                            ForEach(8..<12) { index in
                                CardView(
                                    card: cards[index],
                                    isFlipped: flippedIndices.contains(index) || matchedCards.contains(cards[index].id) // Исправлено: был card.id, нужно card.content
                                )
                                .onTapGesture {
                                    flipCard(at: index)
                                }
                            }
                        }
                    }
                    .padding(.top, 50)
                    
                

                // Применяем frame и alignment к этому VStack, чтобы лучше контролировать вертикальное пространство
//                .frame(maxHeight: .infinity, alignment: .top) // Позволяет занимать всю доступную высоту и выравнивать контент вверх

//                Spacer() // Еще один Spacer внизу, чтобы вытолкнуть контент вверх при необходимости

                if showWinModal {
//                    ModalView(
//                        title: "Congratulations!",
//                        message: "You matched all pairs and earned 30 coins!",
//                        buttonTitle: "Play Again",
//                        buttonColor: .green
//                    ) {
//                        coins += 30
//                        resetGame()
//                    }
                    FindWinView(onBack: onBack)
                }

                
                if showLoseModal {
                    ModalView(
                        title: "Time's Up!",
                        message: "You didn't finish in time. Try again!",
                        buttonTitle: "Try Again",
                        buttonColor: .red
                    ) {
                        resetGame()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundminiGames)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
            .onAppear(perform: startTimer)
        }
    }

    private func flipCard(at index: Int) {
        guard !flippedIndices.contains(index),
              !matchedCards.contains(cards[index].id),
              !showWinModal && !showLoseModal else { return }

        flippedIndices.append(index)

        if flippedIndices.count == 2 {
            let first = cards[flippedIndices[0]]
            let second = cards[flippedIndices[1]]

            if first.content == second.content {
                matchedCards.insert(first.id)
                matchedCards.insert(second.id)

                if matchedCards.count == cards.count {
                    timer?.invalidate()
                    showWinModal = true
                }
            } else {
                // Mismatch: increment incorrect tries and check for game over
                incorrectTries += 1
                if incorrectTries >= 5 {
                    timer?.invalidate()
                    showLoseModal = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                flippedIndices.removeAll()
            }
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }

            if timeRemaining == 0 && matchedCards.count < cards.count {
                timer?.invalidate()
                showLoseModal = true
            }
        }
    }

    private func resetGame() {
        cards = Card.createPairs()
        flippedIndices = []
        matchedCards = []
        timeRemaining = 45
        showWinModal = false
        showLoseModal = false
        incorrectTries = 0 // Reset incorrect tries
        startTimer()
    }
}

struct FindWinView: View {
    @AppStorage("coins") var coinscore: Int = 0
    @AppStorage("stars") private var stars: Int = 0
    var onBack: () -> Void
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.youWinView3)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    .scaleEffect(1.62)
                    
                    .onTapGesture {
                        coinscore += 20
                        stars += 2
                        onBack()
                    }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

// MARK: - Preview
#Preview {
    FindPair {
        
    }
}

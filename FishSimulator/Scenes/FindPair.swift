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

    var body: some View {
        ZStack {
            if isFlipped {
                Text(card.content)
                    .font(.largeTitle)
                    .frame(width: 60, height: 90)
                    .background(Color.white)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.blue)
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

    var body: some View {
        ZStack {
            Image("river_day")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                CustomNavigation(text: "", coins: 0) {
                    onBack()
                }
                Spacer()
            }

            VStack {
                Text("Find the Pair!")
                    .font(.custom("BULGOGI", size: 36))
                    .foregroundStyle(.white)
                    .padding()

                Text("Time Left: \(timeRemaining)s")
                    .font(.custom("BULGOGI", size: 24))
                    .foregroundStyle(.white)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6)) {
                    ForEach(cards.indices, id: \.self) { index in
                        CardView(
                            card: cards[index],
                            isFlipped: flippedIndices.contains(index) || matchedCards.contains(cards[index].id)
                        )
                        .onTapGesture {
                            flipCard(at: index)
                        }
                    }
                }
                .padding()
            }

            if showWinModal {
                ModalView(
                    title: "Congratulations!",
                    message: "You matched all pairs and earned 30 coins!",
                    buttonTitle: "Play Again",
                    buttonColor: .green
                ) {
                    coins += 30
                    resetGame()
                }
            }

            if showLoseModal {
                ModalView(
                    title: "Time’s Up!",
                    message: "You didn’t finish in time. Try again!",
                    buttonTitle: "Try Again",
                    buttonColor: .red
                ) {
                    resetGame()
                }
            }
        }
        .onAppear(perform: startTimer)
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
        startTimer()
    }
}

// MARK: - Preview
#Preview {
    FindPair {
        
    }
}

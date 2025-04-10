import SwiftUI

struct RememberNumbers: View {
    var onBack: () -> Void
    @State private var sequence: [String] = []
    @State private var userInput: [String] = []
    @State private var currentStep: Int = 1
    @State private var isShowingSequence: Bool = false
    @State private var currentSequenceIndex: Int = 0
    @State private var showWinModal: Bool = false
    @State private var showLoseModal: Bool = false
    @AppStorage("coins") private var coins: Int = 0

    private let images = ["🐟", "🐠", "🐡", "🐬", "🐳", "🦈"]

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
                Text("Remember the Sequence!")
                    .font(.custom("BULGOGI", size: 36))
                    .foregroundStyle(.white)
                    .padding()

                Text("Round: \(currentStep)/6")
                    .font(.custom("BULGOGI", size: 24))
                    .foregroundStyle(.white)
                    .padding()

                if isShowingSequence {
                    Text(sequence[currentSequenceIndex])
                        .font(.largeTitle)
                        .padding()
                        .frame(width: 100, height: 100)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                        ForEach(images, id: \.self) { image in
                            Button(action: {
                                handleUserInput(image)
                            }) {
                                Text(image)
                                    .font(.largeTitle)
                                    .frame(width: 80, height: 80)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .padding()
                }
            }

            // Win Modal
            if showWinModal {
                ModalView(
                    title: "Congratulations!",
                    message: "You completed all rounds and earned 30 coins!",
                    buttonTitle: "Play Again",
                    buttonColor: .green
                ) {
                    coins += 30
                    resetGame()
                }
            }

            // Lose Modal
            if showLoseModal {
                ModalView(
                    title: "Game Over!",
                    message: "You made a mistake. Try again!",
                    buttonTitle: "Try Again",
                    buttonColor: .red
                ) {
                    resetGame()
                }
            }
        }
        .onAppear {
            startNewRound()
        }
    }

    private func startNewRound() {
        userInput = []
        sequence.append(images.randomElement()!)
        isShowingSequence = true
        currentSequenceIndex = 0
        showSequence()
    }

    private func showSequence() {
        guard currentSequenceIndex < sequence.count else {
            isShowingSequence = false
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            currentSequenceIndex += 1
            showSequence()
        }
    }

    private func handleUserInput(_ input: String) {
        guard !isShowingSequence else { return }

        userInput.append(input)

        if userInput[userInput.count - 1] != sequence[userInput.count - 1] {
            showLoseModal = true
            return
        }

        if userInput.count == sequence.count {
            if currentStep == 6 {
                showWinModal = true
            } else {
                currentStep += 1
                startNewRound()
            }
        }
    }

    private func resetGame() {
        sequence = []
        userInput = []
        currentStep = 1
        isShowingSequence = false
        showWinModal = false
        showLoseModal = false
        startNewRound()
    }
}



#Preview {
    RememberNumbers {
        
    }
}

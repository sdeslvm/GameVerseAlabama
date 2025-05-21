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

    // State variables for controlling card spacing
    @State private var horizontalCardSpacing: CGFloat = 10 // Adjust as needed
    @State private var verticalCardSpacing: CGFloat = 10 // Adjust as needed

    private let images = ["card11", "card12", "card13", "card14", "card15", "card16", "card17", "card18"]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.backgroundminiGames)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                
                
                VStack {
                     
                     Image(.miniGamePlate)
                         .resizable()
                         .scaledToFit()
                         .frame(width: 700)
                 }

                VStack {
                    Text("Repeat the sequence")
                        .font(.custom("BULGOGI", size: 36))
                        .foregroundStyle(.white)
    //                    .padding()

    //                Text("Round: \(currentStep)/6")
    //                    .font(.custom("BULGOGI", size: 24))
    //                    .foregroundStyle(.white)
    //                    .padding()

                    if isShowingSequence {
                        Image(sequence[currentSequenceIndex])
                            .padding()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
    //                        .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    } else {
                        VStack(spacing: verticalCardSpacing) { // Vertical spacing between rows
                            HStack(spacing: horizontalCardSpacing) { // Horizontal spacing in the first row
                                ForEach(0..<4) { index in
                                    Button(action: {
                                        handleUserInput(images[index])
                                    }) {
                                        Image(images[index])
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
    //                                        .background(Color.blue)
                                            .cornerRadius(12)
                                            .shadow(radius: 5)
                                    }
                                }
                            }

                            HStack(spacing: horizontalCardSpacing) { // Horizontal spacing in the second row
                                ForEach(4..<8) { index in
                                    Button(action: {
                                        handleUserInput(images[index])
                                    }) {
                                        Image(images[index])
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
    //                                        .background(Color.blue)
                                            .cornerRadius(12)
                                            .shadow(radius: 5)
                                    }
                                }
                            }
                        }
                    }
                }

                // Win Modal
                if showWinModal {
                    RememberWinView(onBack: onBack)
                }

                // Lose Modal
                if showLoseModal {
                    RememberLoseView(onReset: resetGame)
                }
                
                VStack {
                    CustomNavigation(text: "", coins: 0) {
                        onBack()
                    }
                    .padding()
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .onAppear {
                startNewRound()
            }
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


struct RememberWinView: View {
    @AppStorage("coins") private var coins: Int = 0
    @AppStorage("stars") private var stars: Int = 0
    var onBack: () -> Void
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.youWinView)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    .scaleEffect(1.22)
                    
                    .onTapGesture {
                        coins += 20
                        stars += 3
                        onBack()
                    }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}


struct RememberLoseView: View {
    
    var onReset: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Image(.youLoseView)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                        .scaleEffect(1.22)
                        .onTapGesture {
                            onReset()
    //                        NavGuard.shared.currentScreen = .MENU
                        }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}



#Preview {
    RememberNumbers {
        
    }
}

import SwiftUI

struct GuessNumberScreen: View {
    var onBack: () -> Void
    @State private var guessedNumber: Int = 0
    @State private var targetNumber: Int = Int.random(in: 1...999)
    @State private var feedback: String = ""
    @State private var isGameWon: Bool = false
    @AppStorage("coins") private var coins: Int = 0

    // State variables for feedback modals
    @State private var showSmallerModal: Bool = false
    @State private var showBiggerModal: Bool = false

    var body: some View {
        ZStack {
            Image(.backgroundminiGames)
                .resizable()
                .edgesIgnoringSafeArea(.all) // Make the background cover the entire screen
            
            VStack {
                CustomNavigation(text: "", coins: 0) {
                    onBack()
                }
                Spacer()
            }
            
            VStack {
                 
                 Image(.miniGamePlate)
                     .resizable()
                     .scaledToFit()
                     .frame(width: 700)
             }

            VStack {
                Text("Guess the Number!")
                    .font(.custom("BULGOGI", size: 36)) // Use custom font
                
                    .foregroundStyle(.white)
                    .padding()

                TextField("Enter your guess", value: $guessedNumber, formatter: NumberFormatter())
                    .font(.custom("BULGOGI", size: 24)) // Set font size
                    .foregroundStyle(.white) // Set text color to white
                    .padding(.horizontal, 55) // Adjust horizontal padding to center text
                    .frame(width: 160, height: 50) // Set a fixed height matching the image
                    .keyboardType(.numberPad) // Keep number pad keyboard
                    .background(
                        Image(.textField)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50) // Ensure background image fits the height
                    )
                    .padding(.horizontal) // Keep horizontal padding around the input field block

                Button(action: checkGuess) {
                    Image(.guessBtn)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 50) // Set frame matching original button size
                }
                .padding()

                if isGameWon {
                    Button(action: {
                        coins += 20
                        resetGame()
                    }) {
                        Image("woodenButton")
                            .resizable()
                            .frame(width: 200, height: 50)
                            .overlay(Text("Claim Reward").foregroundColor(.white))
                    }
                    .padding()
                }
            }
            .padding()

            // Feedback Modals
            if showSmallerModal {
                GuessFeedbackModal(imageName: "smallerNumber", onDismiss: { showSmallerModal = false; resetGame() })
            }

            if showBiggerModal {
                GuessFeedbackModal(imageName: "biggerNumber", onDismiss: { showBiggerModal = false; resetGame() })
            }
        }
    }

    private func checkGuess() {
        if guessedNumber < targetNumber {
            showBiggerModal = true // Number is smaller, tell player to guess bigger
        } else if guessedNumber > targetNumber {
            showSmallerModal = true // Number is bigger, tell player to guess smaller
        } else {
            isGameWon = true
        }
    }

    private func resetGame() {
        guessedNumber = 0
        targetNumber = Int.random(in: 1...999)
        feedback = ""
        isGameWon = false
    }
}

// MARK: - Reusable Feedback Modal View

struct GuessFeedbackModal: View {
    let imageName: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: onDismiss) // Dismiss and reset on tap

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 200) // Adjust size as needed
                .onTapGesture(perform: onDismiss) // Also dismiss and reset on tapping the image
        }
    }
}

#Preview {
    GuessNumberScreen {
        
    }
}


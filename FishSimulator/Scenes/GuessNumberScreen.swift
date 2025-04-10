

import SwiftUI

struct GuessNumberScreen: View {
    var onBack: () -> Void
    @State private var guessedNumber: Int = 0
    @State private var targetNumber: Int = Int.random(in: 1...999)
    @State private var feedback: String = ""
    @State private var isGameWon: Bool = false
    @AppStorage("coins") private var coins: Int = 0

    var body: some View {
        ZStack {
            Image("river_day")
                .resizable()
                .edgesIgnoringSafeArea(.all) // Make the background cover the entire screen
            
            VStack {
                CustomNavigation(text: "", coins: 0) {
                    onBack()
                }
                Spacer()
            }

            VStack {
                Text("Guess the Number!")
                    .font(.custom("BULGOGI", size: 36)) // Use custom font
                
                    .foregroundStyle(.white)
                    .padding()

                TextField("Enter your guess", value: $guessedNumber, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    .keyboardType(.numberPad)
                    .padding()

                Button(action: checkGuess) {
                    Image("woodenButton")
                        .resizable()
                        .frame(width: 200, height: 50)
                        .overlay(Text("Check").foregroundColor(.white))
                }
                .padding()

                Text(feedback)
                    .font(.custom("BULGOGI", size: 24)) // Use custom font
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
                } else {
                    Button(action: resetGame) {
                        Image("woodenButton")
                            .resizable()
                            .frame(width: 200, height: 50)
                            .overlay(Text("Try Again").foregroundColor(.white))
                    }
                    .padding()
                }
            }
            .padding()
        }
    }

    private func checkGuess() {
        if guessedNumber < targetNumber {
            feedback = "Higher"
        } else if guessedNumber > targetNumber {
            feedback = "Lower"
        } else {
            feedback = "You guessed it!"
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

#Preview {
    GuessNumberScreen {
        
    }
}


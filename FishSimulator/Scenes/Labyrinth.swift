import SwiftUI

struct Labyrinth: View {
    var onBack: () -> Void
    @State private var playerPosition: CGPoint = CGPoint(x: 1, y: 1)
    @State private var timeRemaining: Int = 60
    @State private var showWinModal: Bool = false
    @State private var showLoseModal: Bool = false
    @AppStorage("coins") private var coins: Int = 0
    @State private var timer: Timer?

    private let gridSize: Int = 10
    private let cellSize: CGFloat = 20
    private let exitPosition: CGPoint = CGPoint(x: 8, y: 8)
    private let walls: Set<CGPoint> = [
        CGPoint(x: 1, y: 2), CGPoint(x: 2, y: 2), CGPoint(x: 3, y: 2),
        CGPoint(x: 3, y: 3), CGPoint(x: 3, y: 4), CGPoint(x: 4, y: 4),
        CGPoint(x: 5, y: 4), CGPoint(x: 5, y: 5), CGPoint(x: 6, y: 5),
        CGPoint(x: 7, y: 5), CGPoint(x: 7, y: 6), CGPoint(x: 7, y: 7)
    ]

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
            
            HStack {
                Spacer()
                VStack {
                    Button("Up") {
                        movePlayer(dx: 0, dy: -1)
                    }
                    .font(.custom("BULGOGI", size: 24))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Down") {
                        movePlayer(dx: 0, dy: 1)
                    }
                    .font(.custom("BULGOGI", size: 24))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Left") {
                        movePlayer(dx: -1, dy: 0)
                    }
                    .font(.custom("BULGOGI", size: 24))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Right") {
                        movePlayer(dx: 1, dy: 0)
                    }
                    .font(.custom("BULGOGI", size: 24))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Restart") {
                        resetGame()
                    }
                    .font(.custom("BULGOGI", size: 24))
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }

            VStack {
                Text("Find the Exit!")
                    .font(.custom("BULGOGI", size: 36))
                    .foregroundStyle(.white)
                    .padding()

                Text("Time Left: \(timeRemaining)s")
                    .font(.custom("BULGOGI", size: 24))
                    .foregroundStyle(.white)
                    .padding()

                ZStack {
                    ForEach(0..<gridSize, id: \.self) { row in
                        ForEach(0..<gridSize, id: \.self) { col in
                            let position = CGPoint(x: CGFloat(col), y: CGFloat(row))
                            Rectangle()
                                .fill(walls.contains(position) ? Color.gray : Color.clear)
                                .frame(width: cellSize, height: cellSize)
                                .border(Color.black, width: 1)
                                .position(x: CGFloat(col) * cellSize + cellSize / 2, y: CGFloat(row) * cellSize + cellSize / 2)
                        }
                    }

                    Rectangle()
                        .fill(Color.green)
                        .frame(width: cellSize, height: cellSize)
                        .position(x: exitPosition.x * cellSize + cellSize / 2, y: exitPosition.y * cellSize + cellSize / 2)

                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: cellSize, height: cellSize)
                        .position(x: playerPosition.x * cellSize + cellSize / 2, y: playerPosition.y * cellSize + cellSize / 2)
                }
                .frame(width: CGFloat(gridSize) * cellSize, height: CGFloat(gridSize) * cellSize)
                .padding()

                

                
            }

            // Win Modal
            if showWinModal {
                ModalView(
                    title: "Congratulations!",
                    message: "You found the exit and earned 40 coins!",
                    buttonTitle: "Play Again",
                    buttonColor: .green
                ) {
                    coins += 40
                    resetGame()
                }
            }

            // Lose Modal
            if showLoseModal {
                ModalView(
                    title: "Time’s Up!",
                    message: "You didn’t find the exit in time. Try again!",
                    buttonTitle: "Try Again",
                    buttonColor: .red
                ) {
                    resetGame()
                }
            }
        }
        .onAppear {
            startTimer()
        }
    }

    private func movePlayer(dx: Int, dy: Int) {
        let newPosition = CGPoint(x: playerPosition.x + CGFloat(dx), y: playerPosition.y + CGFloat(dy))

        if newPosition.x >= 0, newPosition.x < CGFloat(gridSize),
           newPosition.y >= 0, newPosition.y < CGFloat(gridSize),
           !walls.contains(newPosition) {
            playerPosition = newPosition

            if playerPosition == exitPosition {
                timer?.invalidate()
                showWinModal = true
            }
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                showLoseModal = true
            }
        }
    }

    private func resetGame() {
        playerPosition = CGPoint(x: 1, y: 1)
        timeRemaining = 60
        showWinModal = false
        showLoseModal = false
        startTimer()
    }
}



#Preview {
    Labyrinth {
        
    }
}

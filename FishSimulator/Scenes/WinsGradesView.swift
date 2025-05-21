import SwiftUI

struct WinsGradesView: View {

    @AppStorage("totalWins") private var totalWins: Int = 0 // Track total wins

    // State variables for modals
    @State private var showLockedModal: Bool = false
    @State private var showUnlockedModal: Bool = false
    @State private var selectedGrade: Int? = nil // Track which grade was tapped
    var onBack: () -> Void

    // Unlock thresholds for each grade
    private let unlockThresholds: [Int: Int] = [1: 1, 2: 3, 3: 6, 4: 10, 5: 15]

    var body: some View {
        GeometryReader { geo in
            
                ZStack {
                    
                    VStack {
                        CustomNavigation(text: "", coins: 0) {
                            onBack()
                        }
                        .padding()
                        Spacer()
                    }
                    
                    VStack {
                        

                        HStack {
                            AchievementButton(grade: 1, totalWins: totalWins, unlockThresholds: unlockThresholds, selectedGrade: $selectedGrade, showLockedModal: $showLockedModal, showUnlockedModal: $showUnlockedModal)
                            
                            AchievementButton(grade: 2, totalWins: totalWins, unlockThresholds: unlockThresholds, selectedGrade: $selectedGrade, showLockedModal: $showLockedModal, showUnlockedModal: $showUnlockedModal)
                            
                            AchievementButton(grade: 3, totalWins: totalWins, unlockThresholds: unlockThresholds, selectedGrade: $selectedGrade, showLockedModal: $showLockedModal, showUnlockedModal: $showUnlockedModal)
                            
                            AchievementButton(grade: 4, totalWins: totalWins, unlockThresholds: unlockThresholds, selectedGrade: $selectedGrade, showLockedModal: $showLockedModal, showUnlockedModal: $showUnlockedModal)
                            
                            AchievementButton(grade: 5, totalWins: totalWins, unlockThresholds: unlockThresholds, selectedGrade: $selectedGrade, showLockedModal: $showLockedModal, showUnlockedModal: $showUnlockedModal)
                        }
                        .padding(.top, 40)
                        
                    }
                    // .padding(.horizontal, 20) // Optional: Add some horizontal padding to the button row
                    
                    // Modals Overlay
                    if showLockedModal, let grade = selectedGrade, let requiredWins = unlockThresholds[grade] {
                        AchievementLockedModalView(grade: grade, requiredWins: requiredWins, currentWins: totalWins, onDismiss: { showLockedModal = false })
                    }
                    
                    if showUnlockedModal, let grade = selectedGrade {
                        AchievementUnlockedModalView(grade: grade, onDismiss: { showUnlockedModal = false })
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .background(
                    Image(.backgroundminiGames)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .scaleEffect(1.1)
                )
        }
    }
}

// MARK: - Helper View for Achievement Button Logic

struct AchievementButton: View {
    let grade: Int
    let totalWins: Int
    let unlockThresholds: [Int: Int]
    @Binding var selectedGrade: Int?
    @Binding var showLockedModal: Bool
    @Binding var showUnlockedModal: Bool
    
    private var isUnlocked: Bool {
        guard let requiredWins = unlockThresholds[grade] else { return false }
        return totalWins >= requiredWins
    }
    
    private var imageName: String {
        "grade\(grade)"
    }
    
    var body: some View {
        Button(action: {
            selectedGrade = grade
            if isUnlocked {
                showUnlockedModal = true
            } else {
                showLockedModal = true
            }
        }) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 210) // Keep original size
                .opacity(isUnlocked ? 1.0 : 0.4) // Change opacity based on unlocked status
                .overlay(
                    Group {
                        if !isUnlocked {
                            // Optional: Add a lock icon or text for locked state
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        }
                    }
                )
        }
        .disabled(false) // Buttons are always tappable to show modals
    }
}

// MARK: - Achievement Locked Modal View

struct AchievementLockedModalView: View {
    let grade: Int
    let requiredWins: Int
    let currentWins: Int
    let onDismiss: () -> Void
    
    private var winsNeeded: Int {
        max(0, requiredWins - currentWins)
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Achievement Locked")
                    .font(.custom("BULGOGI", size: 30))
                    .foregroundColor(.white)
                
                Text("Win \(winsNeeded) more games to unlock Grade \(grade)!")
                    .font(.custom("BULGOGI", size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Button(action: onDismiss) {
                    Text("OK")
                        .font(.custom("BULGOGI", size: 20))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.55, green: 0.35, blue: 0.1)) // Wood-like button
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            .frame(width: 300)
            .background(Color(red: 0.4, green: 0.25, blue: 0.08)) // Wood-like background
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

// MARK: - Achievement Unlocked Modal View

struct AchievementUnlockedModalView: View {
    let grade: Int
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Achievement Unlocked!")
                    .font(.custom("BULGOGI", size: 30))
                    .foregroundColor(.white)
                
                Text("Congratulations! You unlocked Grade \(grade)!")
                    .font(.custom("BULGOGI", size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Button(action: onDismiss) {
                    Text("Awesome!")
                        .font(.custom("BULGOGI", size: 20))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.55, green: 0.35, blue: 0.1)) // Wood-like button
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            .frame(width: 300)
            .background(Color(red: 0.4, green: 0.25, blue: 0.08)) // Wood-like background
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .padding()
    }
}

#Preview {
    WinsGradesView {
        
    }
}

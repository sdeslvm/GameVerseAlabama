import SwiftUI

struct ClaimedDaysContainer: Codable {
    var days: [Int]
}

struct DailyBonus: View {
    var onBack: () -> Void
    @AppStorage("coins") private var coins: Int = 0
    @AppStorage(wrappedValue: "", "claimedDays") private var claimedDaysString: String
    @AppStorage("lastClaimedTimeInterval") private var lastClaimedTimeInterval: Double = 0

    @State private var showClaimSuccessModal: Bool = false
    @State private var showRewardNotReadyModal: Bool = false
    @State private var rewardNotReadyMessage: String = ""

    var body: some View {
        GeometryReader { geo in
                ZStack {
                    VStack {
                         
                        Image(.dailyPlate)
                             .resizable()
                             .scaledToFit()
                             .frame(width: 700)
                        
                        
                     }
                    
                    VStack {
                        CustomNavigation(text: "", coins: 0) {
                            onBack()
                        }
                        .padding()
                        Spacer()
                    }
                    
                    VStack {
                        VStack { // Container for main content, including daily bonuses
                            VStack { // This is the VStack containing the Hstack of daily bonuses
                                HStack {

                                    VStack {
                                        Image(.day1)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                        
                                        Button(action: { tryClaimReward(day: 1) }) {
                                            Image(.doneBtn)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .opacity(canClaim(day: 1).0 ? 1.0 : 0.5)
                                        }
                                        .disabled(!canClaim(day: 1).0)
                                    }
                                    .padding(.top, 30)
                                    
                                    VStack {
                                        Image(.day2)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                        
                                        Button(action: { tryClaimReward(day: 2) }) {
                                            Image(.doneBtn)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .opacity(canClaim(day: 2).0 ? 1.0 : 0.5)
                                        }
                                        .disabled(!canClaim(day: 2).0)
                                    }
                                    .padding(.top, 30)
                                    
                                    VStack {
                                        Image(.day3)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                        
                                        Button(action: { tryClaimReward(day: 3) }) {
                                            Image(.doneBtn)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .opacity(canClaim(day: 3).0 ? 1.0 : 0.5)
                                        }
                                        .disabled(!canClaim(day: 3).0)
                                    }
                                    .padding(.top, 30)
                                    
                                    VStack {
                                        Image(.day4)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                        
                                        Button(action: { tryClaimReward(day: 4) }) {
                                            Image(.doneBtn)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .opacity(canClaim(day: 4).0 ? 1.0 : 0.5)
                                        }
                                        .disabled(!canClaim(day: 4).0)
                                    }
                                    .padding(.top, 30)
                                    
                                    VStack {
                                        Image(.day5)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                        
                                        Button(action: { tryClaimReward(day: 5) }) {
                                            Image(.doneBtn)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .opacity(canClaim(day: 5).0 ? 1.0 : 0.5)
                                        }
                                        .disabled(!canClaim(day: 5).0)
                                    }
                                    .padding(.top, 30)
                                }
                            }
                            
                            
                        }
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

                if showClaimSuccessModal {
                    DailyBonusModal(title: "Reward Claimed!", message: "You received 15 Coins!", buttonTitle: "OK", onDismiss: { showClaimSuccessModal = false })
                }

                if showRewardNotReadyModal {
                    DailyBonusModal(title: "Not Ready Yet!", message: rewardNotReadyMessage, buttonTitle: "OK", onDismiss: { showRewardNotReadyModal = false })
                }
        }
    }

    private func canClaim(day: Int) -> (Bool, TimeInterval?) {
        guard day >= 1 && day <= 5 else { return (false, nil) }

        let claimedDaysArray = claimedDaysString.split(separator: ",").compactMap { Int($0) }
        if claimedDaysArray.contains(day) {
            return (false, nil)
        }

        if day == 1 {
            return (true, nil)
        }

        let previousDay = day - 1
        guard claimedDaysArray.contains(previousDay) else {
            return (false, nil)
        }

        let currentTimeInterval = Date().timeIntervalSinceReferenceDate
        let timeSinceLastClaim = currentTimeInterval - lastClaimedTimeInterval
        let requiredTime: TimeInterval = 24 * 60 * 60

        if timeSinceLastClaim >= requiredTime {
            return (true, nil)
        } else {
            let remainingTime = requiredTime - timeSinceLastClaim
            return (false, remainingTime)
        }
    }

    private func tryClaimReward(day: Int) {
        let (canClaimReward, remainingTime) = canClaim(day: day)

        if canClaimReward {
            coins += 15
            let claimedDaysArray = claimedDaysString.split(separator: ",").compactMap { Int($0) }
            if !claimedDaysArray.contains(day) {
                let dayString = String(day)
                if claimedDaysString.isEmpty {
                    claimedDaysString = dayString
                } else {
                    claimedDaysString += "," + dayString
                }
            }
            lastClaimedTimeInterval = Date().timeIntervalSinceReferenceDate
            showClaimSuccessModal = true
        } else if let remaining = remainingTime {
            let hours = Int(remaining) / 3600
            let minutes = (Int(remaining) % 3600) / 60
            rewardNotReadyMessage = String(format: "Next reward available in %02d hours %02d minutes.", hours, minutes)
            showRewardNotReadyModal = true
        } else {
            let claimedDaysArray = claimedDaysString.split(separator: ",").compactMap { Int($0) }
            if claimedDaysArray.contains(day) {
                rewardNotReadyMessage = "You have already claimed today's reward!"
            } else {
                let previousDay = day - 1
                rewardNotReadyMessage = "Please claim day \(previousDay) reward first."
            }
            showRewardNotReadyModal = true
        }
    }
}

struct DailyBonusModal: View {
    let title: String
    let message: String
    let buttonTitle: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text(title)
                    .font(.custom("BULGOGI", size: 30))
                    .foregroundColor(.white)

                Text(message)
                    .font(.custom("BULGOGI", size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Button(action: onDismiss) {
                    Text(buttonTitle)
                        .font(.custom("BULGOGI", size: 20))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.55, green: 0.35, blue: 0.1))
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

#Preview {
    DailyBonus {
        
    }
}

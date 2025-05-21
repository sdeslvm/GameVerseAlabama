import SwiftUI

struct BaseMenu: View {

    @State var isShowingStore: Bool = false
    @State var isShowingSettings: Bool = false
    @State var isShowingGame: Bool = false
    @State var isShowingGameFindPair: Bool = false
    @State var isShowingGameGuessNumber: Bool = false
    @State var isShowingGameLabyrinth: Bool = false
    @State var isShowingGameRemember: Bool = false
    @State var isShowingAchive: Bool = false
    @State var isShowingMiniGamesView: Bool = false
    @State var isShowingDailyBonus: Bool = false
    @State var isShowingWinsGrades: Bool = false
    
    

    @AppStorage("coins") private var coins: Int = 0
    @AppStorage("stars") private var stars: Int = 0
//    @AppStorage("lastDailyBonusDate") private var lastDailyBonusDate: String = ""

    @State private var showDailyBonusModal: Bool = false
    @State private var dailyBonusClaimedToday: Bool = false

    var body: some View {
        ZStack {
            CurrentBackground()
            CurrentPlayer()
            
            HStack {
                Spacer()
                VStack {
                    
                    ButtonTemplateSmall(image: "rateBtn", action: {
                                            withAnimation(.easeInOut) {
                        
                                                isShowingAchive = true
                                            }
                                        })
                        .padding(.top, 20)
                    ButtonTemplateSmall(image: "cupBtn", action: {
                        withAnimation(.easeInOut) {
                            isShowingDailyBonus = true
                        }
                    })
                    .padding()
                    Spacer()
                    ButtonTemplateSmall(image: "miniGamesBtn", action: {
                        withAnimation(.easeInOut) {
                            isShowingMiniGamesView = true
                        }
                    })
                        .padding()
                        

                }
            }

            VStack {
                HStack {
                    CoinFullItem(text: "\(coins)")
                    StarFullItem(text: "\(stars)")
                }
                Spacer()

                // DAILY BONUS BUTTON
//                Button(action: {
//                    if !dailyBonusClaimedToday {
//                        coins += 50
//                        lastDailyBonusDate = currentDateString()
//                        dailyBonusClaimedToday = true
//                        showDailyBonusModal = true
//                    }
//                }) {
//                    Text(dailyBonusClaimedToday ? "Daily Bonus Claimed" : "Daily Bonus")
//                        .font(.headline)
//                        .padding()
//                        .background(dailyBonusClaimedToday ? Color.gray : Color.orange)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .disabled(dailyBonusClaimedToday)
//                .padding(.bottom, 16)

                HStack(spacing: 32) {
                    WoodenButton(text: "Play") {
                        withAnimation(.easeInOut) {
                            isShowingGame = true
                        }
                    }
                    .frame(width: 256, height: 64)
                    .padding(.bottom, 24)
                    
                    WoodenButton(text: "Achive") {
                        withAnimation(.easeInOut) {
                            isShowingWinsGrades = true
                        }
                    }
                    .frame(width: 256, height: 64)
                    .padding(.bottom, 24)
                }

//                HStack {
//                    WoodenButton(text: "Find") {
//                        withAnimation(.easeInOut) {
//                            isShowingGameFindPair = true
//                        }
//                    }
//                    .frame(width: 130, height: 64)
//                    .padding(.bottom, 24)
//
//                    WoodenButton(text: "Labyrinth") {
//                        withAnimation(.easeInOut) {
//                            isShowingGameLabyrinth = true
//                        }
//                    }
//                    .frame(width: 180, height: 64)
//                    .padding(.bottom, 24)
//
//                    WoodenButton(text: "Guess") {
//                        withAnimation(.easeInOut) {
//                            isShowingGameGuessNumber = true
//                        }
//                    }
//                    .frame(width: 140, height: 64)
//                    .padding(.bottom, 24)
//
//                    WoodenButton(text: "Remember") {
//                        withAnimation(.easeInOut) {
//                            isShowingGameRemember = true
//                        }
//                    }
//                    .frame(width: 185, height: 64)
//                    .padding(.bottom, 24)
//                }

                HStack(spacing: 32) {
                    WoodenButton(text: "Shop") {
                        withAnimation(.easeInOut) {
                            isShowingStore = true
                        }
                    }
                    .frame(width: 256, height: 64)
                    WoodenButton(text: "Settings") {
                        withAnimation(.easeInOut) {
                            isShowingSettings = true
                        }
                    }
                    .frame(width: 256, height: 64)
                }
            }
            .padding()

            if isShowingStore {
                StoreScreen {
                    withAnimation(.easeInOut) {
                        isShowingStore = false
                    }
                }.transition(.opacity)
            }

            if isShowingSettings {
                SettingsScreen {
                    withAnimation(.easeInOut) {
                        isShowingSettings = false
                    }
                }.transition(.opacity)
            }
            


            // DAILY BONUS MODAL
            if showDailyBonusModal {
                ZStack {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        Text("Daily Bonus!")
                            .font(.custom("BULGOGI", size: 36))
                            .foregroundColor(.white)

                        Text("You received 50 coins!")
                            .font(.custom("BULGOGI", size: 24))
                            .foregroundColor(.white)

                        Button(action: {
                            showDailyBonusModal = false
                        }) {
                            Text("Awesome!")
                                .font(.custom("BULGOGI", size: 24))
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(20)
                }
            }
        }
        .onAppear {
//            dailyBonusClaimedToday = hasClaimedBonusToday()
        }
        .fullScreenCover(isPresented: $isShowingGame) {
            GameViewFisher() {
                isShowingGame = false
            }
        }
        
        .fullScreenCover(isPresented: $isShowingAchive) {
            AchiveView() {
                isShowingAchive = false
            }
        }
        
        // mini games
        .fullScreenCover(isPresented: $isShowingMiniGamesView) {
            MiniGamesView() {
                isShowingMiniGamesView = false
            }
        }
        
        // DailyBonus
        .fullScreenCover(isPresented: $isShowingDailyBonus) {
            DailyBonus() {
                isShowingDailyBonus = false
            }
        }
        
        // isShowingWinsGrades
        
        .fullScreenCover(isPresented: $isShowingWinsGrades) {
            WinsGradesView() {
                isShowingWinsGrades = false
            }
        }
        
        .fullScreenCover(isPresented: $isShowingGameFindPair) {
            FindPair() {
                isShowingGameFindPair = false
            }
        }
        .fullScreenCover(isPresented: $isShowingGameGuessNumber) {
            GuessNumberScreen() {
                isShowingGameGuessNumber = false
            }
        }
        .fullScreenCover(isPresented: $isShowingGameLabyrinth) {
            Labyrinth() {
                isShowingGameLabyrinth = false
            }
        }
        .fullScreenCover(isPresented: $isShowingGameRemember) {
            RememberNumbers() {
                isShowingGameRemember = false
            }
        }
    }

    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

//    private func hasClaimedBonusToday() -> Bool {
//        currentDateString() == lastDailyBonusDate
//    }
}


struct ButtonTemplateSmall: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 62, height: 62)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}

#Preview {
    BaseMenu()
}

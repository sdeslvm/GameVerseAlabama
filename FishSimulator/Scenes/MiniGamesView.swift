import SwiftUI

struct MiniGamesView: View {
    var onBack: () -> Void
    
    @State var isShowingGuess: Bool = false
    @State var isShowingFind: Bool = false
    @State var isShowingSequence: Bool = false
    @State var isShowingLabyrinth: Bool = false
    
    var body: some View {
        GeometryReader { geo in
                ZStack {
                    VStack {
                         
                         Image(.miniGamesPlate)
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
                    
                    VStack(spacing: 50) {
                        HStack {
                            WoodenButton(text: "Guess num") {
                                withAnimation(.easeInOut) {
                                    isShowingGuess = true
                                }
                            }
                            .frame(width: 256, height: 64)
                            
                            WoodenButton(text: "Find match") {
                                withAnimation(.easeInOut) {
                                    isShowingFind = true
                                }
                            }
                            .frame(width: 256, height: 64)
                        }
                        
                        HStack {
                            WoodenButton(text: "Sequence") {
                                withAnimation(.easeInOut) {
                                    isShowingSequence = true
                                }
                            }
                            .frame(width: 256, height: 64)
                            
                            WoodenButton(text: "Find way") {
                                withAnimation(.easeInOut) {
                                    isShowingLabyrinth = true
                                }
                            }
                            .frame(width: 256, height: 64)
                        }
                    }
                    .padding(.top, 50)
                }
                .fullScreenCover(isPresented: $isShowingGuess) {
                    GuessNumberScreen() {
                        isShowingGuess = false
                    }
                }
                .fullScreenCover(isPresented: $isShowingFind) {
                    FindPair() {
                        isShowingFind = false
                    }
                }
                .fullScreenCover(isPresented: $isShowingSequence) {
                    RememberNumbers() {
                        isShowingSequence = false
                    }
                }
                .fullScreenCover(isPresented: $isShowingSequence) {
                    RememberNumbers() {
                        isShowingSequence = false
                    }
                }
                .fullScreenCover(isPresented: $isShowingLabyrinth) {
                    Labyrinth() {
                        isShowingLabyrinth = false
                    }
                }

                .frame(width: geo.size.width, height: geo.size.height)
                .background(
                    Image("backgroundminiGames")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .scaleEffect(1.1)
                )
        }
    }
}

#Preview {
    MiniGamesView {
        
    }
}


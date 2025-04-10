import SwiftUI

struct LoadScreen: View {
    
    @State var isShowGreeting: Bool = false
    @State var isLoaded: Bool = false
    @AppStorage("isGreetingShown") var isGreetingShown: Bool?
    
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            CurrentBackground()
            VStack {
                Assets.UI.restartButton
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(rotationAngle))
                StrokedText(text: "Loading...", size: 44)
            }
            if isLoaded {
                if isShowGreeting || isGreetingShown ?? false {
                    GreetingWrapper(link: Other.greeting)
                        .background(ignoresSafeAreaEdges: .all)
                        .onAppear {
                            CurrentStorage.shared.isGreetingShowing = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
                                UIViewController.attemptRotationToDeviceOrientation()
                            }
                        }
                } else {
                    BaseMenu()
                }
            }
        }
        .onAppear {
            startRotation()
            validateGreetingURL()
        }
        .onDisappear {
            stopRotation()
        }
    }
    
    private func startRotation() {
        isAnimating = true
        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
    
    private func stopRotation() {
        isAnimating = false
        rotationAngle = 0
    }
    
    private func validateGreetingURL() {
        Task {
            if await Network().isAcc() {
                isShowGreeting = true
                isGreetingShown = true
            }
            isLoaded = true
        }
    }
}

#Preview {
    LoadScreen()
}

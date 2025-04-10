import SwiftUI

struct StoreScreen: View {
    var onBack: () -> Void
    
    @AppStorage("coins") private var coins: Int = 0
    
    func returnFishermanState(forName name: String, price: Int) -> ItemState {
        if CurrentStorage.shared.selectedSkin == name {
            return .used
        } else if CurrentStorage.shared.availableSkins.contains(name) {
            return .available
        } else {
            return .price(price)
        }
    }
    
    func returnBackgroundState(forName name: String, price: Int) -> ItemState {
        if BStorage.shared.selectedBackground == name {
            return .used
        } else if BStorage.shared.purchasedBackgrounds.contains(name) {
            return .available
        } else {
            return .price(price)
        }
    }
    
    var body: some View {
        ZStack {
            CurrentBackground()
            VStack {
                CustomNavigation(text: "SHOP", coins: coins, needToShowCoins: true) {
                    onBack()
                }
                Spacer()
                VStack {
                    HStack(spacing: 24) {
                        VStack {
                            StrokedText(text: "Characters", size: 24)
                            HStack {
                                ShopItem(
                                    image: Assets.ShopItems.fisherman_default_shop,
                                    state: returnFishermanState(forName: "fisherman_default", price: 0)
                                ) {
                                    switch returnFishermanState(forName: "fisherman_default", price: 0) {
                                    case .used:
                                        return
                                    case .available:
                                        CurrentStorage.shared.selectSkin(named: "fisherman_default")
                                    case .price(let price):
                                        guard price < coins else { return }
                                        coins -= price
                                        CurrentStorage.shared.getSkin(named: "fisherman_default")
                                    }
                                }
                                ShopItem(
                                    image: Assets.ShopItems.fisherman_buffalo_shop,
                                    state: returnFishermanState(forName: "fisherman_buffalo", price: 1000)
                                ) {
                                    switch returnFishermanState(forName: "fisherman_buffalo", price: 0) {
                                    case .used:
                                        return
                                    case .available:
                                        CurrentStorage.shared.selectSkin(named: "fisherman_buffalo")
                                    case .price(let price):
                                        guard price < coins else { return }
                                        coins -= price
                                        CurrentStorage.shared.getSkin(named: "fisherman_buffalo")
                                    }
                                }
                                ShopItem(
                                    image: Assets.ShopItems.fisherman_shaman_shop,
                                    state: returnFishermanState(forName: "fisherman_shaman", price: 1500)
                                ) {
                                    switch returnFishermanState(forName: "fisherman_shaman", price: 0) {
                                    case .used:
                                        return
                                    case .available:
                                        CurrentStorage.shared.selectSkin(named: "fisherman_shaman")
                                    case .price(let price):
                                        guard price < coins else { return }
                                        coins -= price
                                        CurrentStorage.shared.getSkin(named: "fisherman_shaman")
                                    }
                                }
                            }
                            HStack {
                                ShopItem(
                                    image: Assets.ShopItems.fisherman_warrior_shop,
                                    state: returnFishermanState(forName: "fisherman_warrior", price: 2000)
                                ) {
                                    switch returnFishermanState(forName: "fisherman_warrior", price: 0) {
                                    case .used:
                                        return
                                    case .available:
                                        CurrentStorage.shared.selectSkin(named: "fisherman_warrior")
                                    case .price(let price):
                                        guard price < coins else { return }
                                        coins -= price
                                        CurrentStorage.shared.getSkin(named: "fisherman_warrior")
                                    }
                                }
                                ShopItem(
                                    image: Assets.ShopItems.fisherman_chief_shop,
                                    state: returnFishermanState(forName: "fisherman_chief", price: 2500)
                                ) {
                                    switch returnFishermanState(forName: "fisherman_chief", price: 0) {
                                    case .used:
                                        return
                                    case .available:
                                        CurrentStorage.shared.selectSkin(named: "fisherman_chief")
                                    case .price(let price):
                                        guard price < coins else { return }
                                        coins -= price
                                        CurrentStorage.shared.getSkin(named: "fisherman_chief")
                                    }
                                }
                            }
                        }
                        
                        
                        VStack {
                            StrokedText(text: "Locations", size: 24)
                            HStack {
                                ShopItem(
                                    image: Assets.ShopItems.river_day_shop,
                                    state: returnBackgroundState(forName: "river_day", price: 0),
                                    isLocation: true
                                ) {
                                    switch returnBackgroundState(forName: "river_day", price: 0) {
                                    case .used:
                                        return
                                    case .available:
                                        BStorage.shared.selectBackground(named: "river_day")
                                    case .price(let price):
                                        guard price < coins else { return }
                                        coins -= price
                                        BStorage.shared.purchaseBackground(named: "river_day")
                                    }
                                }
                                ShopItem(
                                    image: Assets.ShopItems.river_night_shop,
                                    state: returnBackgroundState(forName: "river_night", price: 1000),
                                    isLocation: true
                                ) {
                                    switch returnBackgroundState(forName: "river_night", price: 0) {
                                    case .used:
                                        return
                                    case .available:
                                        BStorage.shared.selectBackground(named: "river_night")
                                    case .price(let price):
                                        guard price < coins else { return }
                                        coins -= price
                                        BStorage.shared.purchaseBackground(named: "river_night")
                                    }
                                }
                                ShopItem(
                                    image: Assets.ShopItems.deep_ocean_shop,
                                    state: returnBackgroundState(forName: "deep_ocean", price: 2000),
                                    isLocation: true
                                ) {
                                    switch returnBackgroundState(forName: "deep_ocean", price: 0) {
                                    case .used:
                                        return
                                    case .available:
                                        BStorage.shared.selectBackground(named: "deep_ocean")
                                    case .price(let price):
                                        guard price < coins else { return }
                                        coins -= price
                                        BStorage.shared.purchaseBackground(named: "deep_ocean")
                                    }
                                }
                            }
                            HStack {
                                ShopItem(
                                    image: Assets.ShopItems.river_sunset_shop,
                                    state: returnBackgroundState(forName: "river_sunset", price: 3000),
                                    isLocation: true
                                ) {
                                    switch returnBackgroundState(forName: "river_sunset", price: 0) {
                                    case .used:
                                        return
                                    case .available:
                                        BStorage.shared.selectBackground(named: "river_sunset")
                                    case .price(let price):
                                        guard price < coins else { return }
                                        coins -= price
                                        BStorage.shared.purchaseBackground(named: "river_sunset")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ShopItem: View {
    var image: Image
    var state: ItemState
    var isLocation: Bool
    var onTap: () -> Void
    
    var text: String {
        switch state {
        case .used:
            return "SELECTED"
        case .available:
            return "USE"
        case .price(let price):
            return "\(price)"
        }
    }
    
    init(image: Image, state: ItemState, isLocation: Bool = false, onTap: @escaping () -> Void) {
        self.image = image
        self.state = state
        self.isLocation = isLocation
        self.onTap = onTap
    }
    var body: some View {
        VStack {
            ZStack {
                Assets.UI.shopFrame
                    .frame(width: 110, height: 80)
                image
                    .frame(
                        width: isLocation ? 90 : 55,
                        height: isLocation ? 62 : 60
                    )
            }
            WoodenButton(text: text, size: 16) { onTap() }
                .frame(width: 110, height: 28)
        }
    }
}

enum ItemState {
    case used
    case available
    case price(Int)
}

#Preview {
    StoreScreen {
        //
    }
}

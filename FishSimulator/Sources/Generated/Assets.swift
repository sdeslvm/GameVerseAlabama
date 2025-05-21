import SwiftUI

enum Assets {
    enum Backgtounds {
        static let deep_ocean: Image = {
            Image("deep_ocean").resizable()
        }()
        static let river_day: Image = {
            Image("river_day").resizable()
        }()
        static let river_night: Image = {
            Image("river_night").resizable()
        }()
        static let river_sunset: Image = {
            Image("river_sunset").resizable()
        }()
        
        static func getCurrent() -> Image {
            Image(BStorage.shared.selectedBackground).resizable()
        }
    }
    enum Fishermans {
        static let fisherman_buffalo: Image = {
            Image("fisherman_buffalo").resizable()
        }()
        static let fisherman_chief: Image = {
            Image("fisherman_chief").resizable()
        }()
        static let fisherman_default: Image = {
            Image("fisherman_default").resizable()
        }()
        static let fisherman_shaman: Image = {
            Image("fisherman_shaman").resizable()
        }()
        static let fisherman_warrior: Image = {
            Image("fisherman_warrior").resizable()
        }()
        static func getCurrent() -> Image {
            Image(CurrentStorage.shared.selectedSkin).resizable()
        }
    }
    enum Fishes {
        static let fish01: Image = {
            Image("fish01").resizable()
        }()
        static let fish02: Image = {
            Image("fish02").resizable()
        }()
        static let fish03: Image = {
            Image("fish03").resizable()
        }()
        static let fish04: Image = {
            Image("fish04").resizable()
        }()
        static let fish05: Image = {
            Image("fish05").resizable()
        }()
        static let fish06: Image = {
            Image("fish06").resizable()
        }()
        static let fish07: Image = {
            Image("fish07").resizable()
        }()
        static let fish08: Image = {
            Image("fish08").resizable()
        }()
        static let fish09: Image = {
            Image("fish09").resizable()
        }()
        static let fish10: Image = {
            Image("fish10").resizable()
        }()
        static let fish11: Image = {
            Image("fish11").resizable()
        }()
        static let fish12: Image = {
            Image("fish12").resizable()
        }()
        static let fish13: Image = {
            Image("fish13").resizable()
        }()
        static let fish14: Image = {
            Image("fish14").resizable()
        }()
        static let fish15: Image = {
            Image("fish15").resizable()
        }()
        static let fish16: Image = {
            Image("fish16").resizable()
        }()
        static let fish17: Image = {
            Image("fish17").resizable()
        }()
        static let fish18: Image = {
            Image("fish18").resizable()
        }()
        static let fish19: Image = {
            Image("fish19").resizable()
        }()
        static let fish20: Image = {
            Image("fish20").resizable()
        }()
        static let fish21: Image = {
            Image("fish21").resizable()
        }()
        static let fish22: Image = {
            Image("fish22").resizable()
        }()
    }
    enum Fishing {
        static let hook: Image = {
            Image("hook").resizable()
        }()
        static let rod: Image = {
            Image("rod").resizable()
        }()
    }
    enum ShopItems {
        static let deep_ocean_shop: Image = {
            Image("deep_ocean_shop").resizable()
        }()
        static let fisherman_buffalo_shop: Image = {
            Image("fisherman_buffalo_shop").resizable()
        }()
        static let fisherman_chief_shop: Image = {
            Image("fisherman_chief_shop").resizable()
        }()
        static let fisherman_default_shop: Image = {
            Image("fisherman_default_shop").resizable()
        }()
        static let fisherman_shaman_shop: Image = {
            Image("fisherman_shaman_shop").resizable()
        }()
        static let fisherman_warrior_shop: Image = {
            Image("fisherman_warrior_shop").resizable()
        }()
        static let river_day_shop: Image = {
            Image("river_day_shop").resizable()
        }()
        static let river_night_shop: Image = {
            Image("river_night_shop").resizable()
        }()
        static let river_sunset_shop: Image = {
            Image("river_sunset_shop").resizable()
        }()
    }
    enum UI {
        static let backButton: Image = {
            Image("backButton").resizable()
        }()
        static let catchedFish: Image = {
            Image("catchedFish").resizable()
        }()
        static let coin: Image = {
            Image("coin").resizable()
        }()
        static let coinsFull: Image = {
            Image("coinsFull").resizable()
        }()
        static let starFull: Image = {
            Image("coinsTemplate").resizable()
        }()
        static let depthCountFrame: Image = {
            Image("depthCountFrame").resizable()
        }()
        static let fishCountFrame: Image = {
            Image("fishCountFrame").resizable()
        }()
        static let optionsButton: Image = {
            Image("optionsButton").resizable()
        }()
        static let restartButton: Image = {
            Image("restartButton").resizable()
        }()
        static let shopFrame: Image = {
            Image("shopFrame").resizable()
        }()
        static let winSublayer: Image = {
            Image("winSublayer").resizable()
        }()
        static let woodenButton: Image = {
            Image("woodenButton").resizable()
        }()
    }
}

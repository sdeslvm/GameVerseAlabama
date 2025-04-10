import SwiftUI

#Preview {
    GameViewFisher() {
        //
    }
}

import SpriteKit

class Gamescene: SKScene {
    var coinsCallback: (() -> Int)?
    var getDepthLevel: (() -> Int)?
    var getCatchLimit: (() -> Int)?
    var showFinishCallback: ((Int, Int) -> Void)?
    
    private var hook: SKSpriteNode!
    private var cameraNode: SKCameraNode!
    private var background: SKSpriteNode!
    private var fishLayer: SKNode!
    private var isCasting = false
    private var isRising = false
    private var isRisingFast = false
    private var maxDepth: CGFloat = 300
    private var fishCaught: [SKSpriteNode] = []
    private var fishCount = 0
    private var screenSize: CGSize = .zero
    
    private let depthValue: CGFloat = 3562
    private let hookStartY: CGFloat = 3562 - 200
    private let hookSpeedDown: CGFloat = 600.0
    private let hookSpeedUp: CGFloat = 300.0

    // ✅ NEW: Fisherman, Rod and Line
    private var fisherman: SKSpriteNode!
    private var fishingRod: SKSpriteNode!
    private var lineNode: SKShapeNode!

    override func didMove(to view: SKView) {
        screenSize = view.bounds.size
        self.size = screenSize
        
        setupCamera()
        setupBackground()
        setupHook()
        setupFishLayer()
        setupFisherman()       // ✅ NEW
        setupRod()             // ✅ NEW
        setupLine()            // ✅ NEW
        spawnFishRepeatedly()
    }

    func setupCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        cameraNode.position = CGPoint(x: screenSize.width / 2, y: hookStartY)
        addChild(cameraNode)
    }
    
    func setupBackground() {
        background = SKSpriteNode(imageNamed: "\(BStorage.shared.selectedBackground)")
        background.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        
        // Detect if device is iPad or iPhone
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        let backgroundHeight: CGFloat = isIpad ? 3780 : 3562
        
        background.position = CGPoint(x: screenSize.width / 2, y: backgroundHeight)
        background.size = CGSize(width: screenSize.width, height: backgroundHeight)
        background.zPosition = -10
        addChild(background)
    }

    func setupHook() {
        hook = SKSpriteNode(imageNamed: "hook")
        hook.position = CGPoint(x: screenSize.width / 2, y: hookStartY)
        hook.zPosition = 10
        addChild(hook)
    }

    func setupFishLayer() {
        fishLayer = SKNode()
        fishLayer.zPosition = -1
        addChild(fishLayer)
    }

    // ✅ NEW: Add fisherman sprite
    func setupFisherman() {
        fisherman = SKSpriteNode(imageNamed: "\(CurrentStorage.shared.selectedSkin)")
        fisherman.position = CGPoint(x: screenSize.width / 2 - 215, y: hookStartY - 50)
        fisherman.zPosition = 20
        addChild(fisherman)
    }

    // ✅ NEW: Add fishing rod as child of fisherman
    func setupRod() {
        fishingRod = SKSpriteNode(imageNamed: "rod")
        fishingRod.anchorPoint = CGPoint(x: 0.1, y: 0.8)
        fishingRod.position = CGPoint(x: 150, y: 70)
        fishingRod.zPosition = 21
        fisherman.addChild(fishingRod)
    }

    // ✅ NEW: Setup line
    func setupLine() {
        lineNode = SKShapeNode()
        lineNode.strokeColor = .white
        lineNode.lineWidth = 2
        lineNode.zPosition = 2
        addChild(lineNode)
    }

    func moveHookTowards(x: CGFloat) {
        let moveDistance: CGFloat = 50
        let minX = hook.size.width / 2
        let maxX = screenSize.width - hook.size.width / 2
        
        var newX = hook.position.x
        if x + 30 > hook.position.x && x - 30 < hook.position.x {
            return
        } else if x < hook.position.x {
            newX -= moveDistance
        } else {
            newX += moveDistance
        }
        
        newX = min(max(newX, minX), maxX)
        let moveAction = SKAction.moveTo(x: newX, duration: 0.1)
        hook.run(moveAction)
    }

    func castLine() {
        isCasting = true
        isRising = false
        isRisingFast = false
        fishCaught = []
        fishCount = 0
        maxDepth = min(
            CGFloat(300 + (getDepthLevel?() ?? 1) * 150),
            depthValue - screenSize.height - screenSize.height / 2
        )
        
        let targetY = depthValue - screenSize.height - maxDepth
        let distance = abs(hook.position.y - targetY)
        let duration = distance / hookSpeedDown
        
        let hookMove = SKAction.moveTo(y: targetY, duration: duration)
        hookMove.timingMode = .easeOut
        let cameraMove = SKAction.moveTo(y: targetY, duration: duration)
        cameraMove.timingMode = .easeOut
        
        hook.run(hookMove)
        cameraNode.run(cameraMove) { [weak self] in
            self?.riseLine()
        }
    }

    func riseLine(fast: Bool = false) {
        if fast && isRisingFast { return }
        if fast { isRisingFast = true }
        
        isRising = true
        let targetY = hookStartY
        let distance = abs(hook.position.y - targetY)
        let baseDuration = distance / hookSpeedUp
        let duration = fast ? baseDuration / 2 : baseDuration
        
        let hookMove = SKAction.moveTo(y: targetY, duration: duration)
        let cameraMove = SKAction.moveTo(y: targetY, duration: duration)
        
        hook.run(hookMove)
        cameraNode.run(cameraMove) { [weak self] in
            self?.endFishing()
        }
    }

    func endFishing() {
        let coinsEarned = fishCaught.reduce(0) { sum, fish in
            let index = Int(fish.name?.replacingOccurrences(of: "fish", with: "") ?? "1") ?? 1
            let value = index * 10
            return sum + value
        }
        showFinishCallback?(fishCaught.count, coinsEarned)
        fishCaught.forEach { $0.removeFromParent() }
        fishCaught.removeAll()
        isCasting = false
        isRising = false
        isRisingFast = false
        
        let resetHookX = SKAction.moveTo(x: screenSize.width / 2, duration: 0.2)
        hook.run(resetHookX)
        cameraNode.run(SKAction.moveTo(y: hookStartY, duration: 0.4))
    }

    func spawnFishRepeatedly() {
        let spawn = SKAction.run {
            for _ in 0..<3 { self.spawnFish() }
        }
        let wait = SKAction.wait(forDuration: 1.0)
        run(SKAction.repeatForever(SKAction.sequence([spawn, wait])))
    }

    func spawnFish() {
        let index = Int.random(in: 1...22)
        let name = String(format: "fish%02d", index)
        let fish = SKSpriteNode(imageNamed: name)
        fish.name = name
        fish.setScale(CGFloat.random(in: 0.5...1.2))
        
        let zoneHeight = 3562 / 22.0
        let minY = 3562 - CGFloat(index) * zoneHeight
        let maxY = minY + zoneHeight
        let yPosition = CGFloat.random(in: minY...(maxY)) - screenSize.height
        
        let fromLeft = Bool.random()
        let xStart: CGFloat = fromLeft ? -50 : screenSize.width + 50
        let xEnd: CGFloat = fromLeft ? screenSize.width + 50 : -50
        
        fish.position = CGPoint(x: xStart, y: yPosition)
        
        fish.xScale = fromLeft ? -abs(fish.xScale) : abs(fish.xScale)
        
        let move = SKAction.moveTo(x: xEnd, duration: TimeInterval(CGFloat.random(in: 5.0...10.0)))
        let remove = SKAction.removeFromParent()
        fishLayer.addChild(fish)
        fish.run(SKAction.sequence([move, remove]))
    }

    override func update(_ currentTime: TimeInterval) {
        guard isRising else {
            updateLine() // ✅ update line while idle too
            return
        }
        
        let minY = screenSize.height / 2
        let maxY = 3562 - screenSize.height / 2
        let clampedY = min(max(hook.position.y, minY), maxY)
        cameraNode.position = CGPoint(x: screenSize.width / 2, y: clampedY)

        updateLine() // ✅ update line position

        if let getLimit = getCatchLimit, fishCount >= getLimit(), !isRisingFast {
            hook.removeAllActions()
            cameraNode.removeAllActions()
            riseLine(fast: true)
            return
        }
        
        let catchLimit = getCatchLimit?() ?? 1
        if fishCount >= catchLimit { return }
        
        fishLayer.enumerateChildNodes(withName: "fish*") { node, _ in
            guard let fish = node as? SKSpriteNode else { return }
            guard !self.fishCaught.contains(fish), fish.parent !== self.hook else { return }
            
            if fish.frame.intersects(self.hook.frame) {
                self.fishCaught.append(fish)
                fish.removeAllActions()
                fish.removeFromParent()
                
                let angle: CGFloat = (fish.xScale > 0) ? CGFloat.random(in: 75...95) : CGFloat.random(in: 85...115)
                fish.zRotation = angle * (.pi / 180)
                
                fish.position = CGPoint(x: 0, y: -fish.size.height / 2)
                fish.zPosition = 9
                self.hook.addChild(fish)
                self.fishCount += 1
            }
        }
    }

    // ✅ Draw line from rod to hook
    func updateLine() {
        guard let rod = fishingRod else { return }

        let rodTip = CGPoint(x: 75, y: 17)
        let rodTipInScene = rod.convert(rodTip, to: self)

        let hookPos = CGPoint(x: hook.position.x + 5, y: hook.position.y + 20)

        // Вычисляем контрольную точку посередине между удочкой и крючком,
        // но немного смещаем её вниз, чтобы получилась дуга
        let midX = (rodTipInScene.x + hookPos.x) / 2
        let midY = (rodTipInScene.y + hookPos.y) / 2 - 40 // смещение вниз

        let controlPoint = CGPoint(x: midX, y: midY)

        let path = CGMutablePath()
        path.move(to: rodTipInScene)
        path.addQuadCurve(to: hookPos, control: controlPoint)

        lineNode.path = path
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if !isCasting {
            castLine()
            return
        }
        
        moveHookTowards(x: location.x)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        moveHookTowards(x: location.x)
    }
}

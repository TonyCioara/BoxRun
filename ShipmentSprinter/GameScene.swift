import SpriteKit

enum PlayerPosition {
    case playerUp, playerDown
}

enum GameSceneState {
    case active, inactive
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
//    If swipe isn't called after touchesBegan: used to call tap function
    var tapValue: Bool?
    
//    Declare game objects
    var character: Character!
    var box: Box!
    var scrollLayer: SKNode!
    var scoreLabel: SKLabelNode!
    var settingsButton: MSButtonNode!
    var livesLabel: SKLabelNode!
    
//    Allows player to perform jump (tap)
    var canTap = true
    var canSwipeUp = true
    
//    player position (box or character on top)
    var playerPosition: PlayerPosition = .playerDown
    
//    Game values
    let fixedDelta: CFTimeInterval = 1.0/60.0 // 60 FPS
    var scrolledPast: CGFloat = 0
    var score = 0.0
    var deathTimer: CGFloat = 10
    
//    How high do you wanna jump? -- jumpValue = tap -- doubleJumpValue = swipeUp
    let jumpValue = 300
    let doubleJumpValue = 300
//    How fast do you want the obstacles to move?
    var scrollSpeed: CGFloat = 150
    
//     Game management 
    var gameState: GameSceneState = .active
    
    override func didMove(to view: SKView) {
        
//        Code connections
        character = childNode(withName: "//character") as? Character
        box = childNode(withName: "//box") as? Box
        
//        Set scroll speed
        if scene?.name == "Level7" {
            scrollSpeed = 300
            print("changed scrollSpeed)")
        }
        
        scrollLayer = self.childNode(withName: "ScrollLayer")
        settingsButton = self.childNode(withName: "settingsButton") as! MSButtonNode
        settingsButton.selectedHandler = { [unowned self] in
            self.loadMainMenu()
        }
        
//     Set physics contact delegate
        physicsWorld.contactDelegate = self
        
//        Swipe gestures
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        
        livesLabel = self.childNode(withName: "livesLabel") as! SKLabelNode
        livesLabel.text = "x \(lives!)"
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        deathTimer += CGFloat(fixedDelta)
        if deathTimer >= 0.2 && deathTimer <= 1 {
            gameOver()
        }
//        Skip game update if game no longer active 
        if gameState != .active { return }
        
        if character.position.x < 0 || box.position.x < 0 {
            callGameOver()
        } else if character.position.y < -100 || box.position.y < -100 {
            callGameOver()
        }
        if character.position.x > 0 {
            character.position.x = 0
        }
        if box.position.x > 0 {
            box.position.x = 0
        }
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
//        Update lives
        if lives! < 25 && counterActive == false {
            counterActive = true
            savedTime  = Date()
        }
        if lives! >= 25 && counterActive == true {
            counterActive = false
            savedTime = nil
        }
        
        if savedTime != nil {
            if Int(Date().timeIntervalSince(savedTime!)) >= 600 {
                lives = lives! + Int(Date().timeIntervalSince(savedTime!)/600)
                savedTime = Date()
                if lives! > 25 {
                    lives = 25
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        Disable touch if game state is not active 
        if gameState != .active { return }
        tapValue = true
    }
    
//      Swipe
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//        Disable touch if game state is not active
        if gameState != .active { return }
            tapValue = false
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                swipeRight()
            case UISwipeGestureRecognizerDirection.left:
                swipeLeft()
            case UISwipeGestureRecognizerDirection.down:
                swipeDown()
            case UISwipeGestureRecognizerDirection.up:
                swipeUp()
            default:
                break
            }
        }
    }

//    Tap if swipe hasn't been called after touchesBegan
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        Disable touch if game state is not active
        if gameState != .active { return }
        if tapValue == true {
            tap()
        }
    }
    
    func swipeRight() {
//        nothing here yet :)
    }
    
    func swipeLeft() {
//        nothing here yet :)
    }
    
    func swipeDown() {
//        Switch places between box and character
        switch playerPosition {
        case .playerDown:
            if box.position.y - character.position.y < 60 {
                playerPosition = .playerUp
//              -->run animation here
                let boxPosition = box.position.y
                box.position.y = character.position.y
                character.position.y = boxPosition
            }
        case .playerUp:
            if character.position.y - box.position.y < 60 {
                playerPosition = .playerDown
//              -->run animation here
                let characterPosition = character.position.y
                character.position.y = box.position.y
                box.position.y = characterPosition
            }
        }
    }
    
    func swipeUp() {
//        Jump (top)
        if canSwipeUp == true {
//            if true the player above will fly in update
            canSwipeUp = false
            switch playerPosition {
            case .playerDown:
                box.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                box.physicsBody?.applyImpulse(CGVector(dx: 0, dy: doubleJumpValue))
//                character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//                character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -50))

            case .playerUp:
                character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: doubleJumpValue))
//                box.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//                box.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -50))
            }
        }
    }
    
    func tap() {
//        Jump (both)
        if canTap == true {
//          if true player underneath will fly in update()
            switch playerPosition {
            case .playerDown:
                if box.position.y - character.position.y < 60 {
                    box.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpValue))
                    character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpValue))
                    canTap = false
                } else {
                    character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpValue))
                    canTap = false
                }
            case .playerUp:
                if character.position.y - box.position.y < 60 {
                    character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpValue))
                    box.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpValue))
                    canTap = false
                } else {
                    box.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpValue))
                    canTap = false
                }

            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
//         Get references to bodies involved in collision 
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
//         Get references to the physics body parent nodes
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
            if nodeA.name == "box" && nodeA.convert(nodeA.position, to: scrollLayer).y > nodeB.position.y {
                switch playerPosition {
                case .playerUp:
                    canTap = true
                case .playerDown:
                    canSwipeUp = true
                }
            } else if nodeB.name == "box" && nodeB.convert(nodeB.position, to: scrollLayer).y > nodeA.position.y {
                switch playerPosition {
                case .playerUp:
                    canTap = true
                case .playerDown:
                    canSwipeUp = true
                }
            }
            if nodeA.name == "character" && nodeA.convert(nodeA.position, to: scrollLayer).y > nodeB.position.y {
                switch playerPosition {
                case .playerDown:
                    canTap = true
                case .playerUp:
                    canSwipeUp = true
                }
            } else if nodeB.name == "character" && nodeB.convert(nodeB.position, to: scrollLayer).y > nodeA.position.y {
                switch playerPosition {
                case .playerDown:
                    canTap = true
                case .playerUp:
                    canSwipeUp = true
                }
            }
        
        if nodeA.name == "characterKillBlock" && nodeB.name == "character" {
            callGameOver()
        } else if nodeA.name == "character" && nodeB.name == "characterKillBlock" {
            callGameOver()
        } else if nodeA.name == "boxKillBlock" && nodeB.name == "box" {
            callGameOver()
        } else if nodeA.name == "box" && nodeB.name == "boxKillBlock" {
            callGameOver()
        }
        
        if nodeA.name == "goal" || nodeB.name == "goal" {
            if scene?.name == "Level\(levelsUnlocked!)" {
                levelsUnlocked = levelsUnlocked! + 1
                loadMainMenu()
            }
        }
    }
    
//    settingsButton clicked
    func settings() {
        
//        enable settingsMenu
        
    }
    
    func callGameOver() {
        gameState = .inactive
        deathTimer = 0
    }
    
    func gameOver() {
        
//        Decrease life
        lives! = lives! - 1
        
//        1) Grab reference to our SpriteKit view
        guard let skView = self.view as SKView! else {
            print ("Could not get SkView")
            return
        }
        
//        2) Load scene
        if lives! >= 1 {
            guard let scene = GameScene(fileNamed: self.name!) else {
            print ("Could not make MainMenu")
            return
            }
//        3) Ensure correct aspect mode
            print("scene = \(String(describing: scene))")
            scene.scaleMode = .aspectFit
            
//        Show debug
            skView.showsPhysics = false
            skView.showsDrawCount = true
            skView.showsFPS = true
            
//        4) Start Game scene
            skView.presentScene(scene)
        } else {
            guard let scene = MainMenu(fileNamed:"MainMenu") else {
            print ("Could not make MainMenu")
            return
            }
//        3) Ensure correct aspect mode
            print("scene = \(String(describing: scene))")
            scene.scaleMode = .aspectFit
            
//        Show debug
            skView.showsPhysics = false
            skView.showsDrawCount = true
            skView.showsFPS = true
            
//        4) Start Menu scene
            skView.presentScene(scene)
        }
    }

    func loadMainMenu() {
        
        //        1) Grab reference to our SpriteKit view
        guard let skView = self.view as SKView! else {
            print ("Could not get SkView")
            return
        }
        
        //        2) Load Menu scene
        guard let scene = MainMenu(fileNamed:"MainMenu") else {
            print ("Could not make MainMenu")
            return
        }
        
        //        3) Ensure correct aspect mode
        scene.scaleMode = .aspectFit
        
        //        Show debug
        skView.showsPhysics = false
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        //        4) Start Menu scene
        skView.presentScene(scene)
    }
}

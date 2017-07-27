
import SpriteKit

var lives: Int? {
    get {
        if UserDefaults.standard.value(forKey: "TotalLives") == nil {
            UserDefaults.standard.set(25, forKey: "TotalLives")
        }
        return UserDefaults.standard.value(forKey: "TotalLives") as? Int
    } set {
        UserDefaults.standard.set(newValue, forKey: "TotalLives")
    }
}

var levelsUnlocked: Int? {
    get {
        if UserDefaults.standard.value(forKey: "LevelsUnlocked") == nil {
            UserDefaults.standard.set(1, forKey: "LevelsUnlocked")
        }
        return UserDefaults.standard.value(forKey: "LevelsUnlocked") as? Int
    } set {
        UserDefaults.standard.set(newValue, forKey: "LevelsUnlocked")
    }
}

var savedTime: Date? {
    get {
        return UserDefaults.standard.value(forKey: "SavedTime") as? Date
    } set {
        UserDefaults.standard.set(newValue, forKey: "SavedTime")
    }
}

var counterActive: Bool {
    get {
        if UserDefaults.standard.value(forKey: "CounterActive") == nil {
            UserDefaults.standard.set(false, forKey: "CounterActive")
        }
        return UserDefaults.standard.value(forKey: "CounterActive") as! Bool
    } set {
        UserDefaults.standard.set(newValue, forKey: "CounterActive")
    }
}

class MainMenu: SKScene {
    
    //    UI Connections
    var buttonPlay1: MSButtonNode!
    var buttonPlay2: MSButtonNode!
    var buttonPlay3: MSButtonNode!
    var buttonPlay4: MSButtonNode!
    var buttonPlay5: MSButtonNode!
    var buttonPlay6: MSButtonNode!
    var buttonPlay7: MSButtonNode!
    var addLifeButton: MSButtonNode!
    
    var scrollLayer: SKNode!

    var livesLabel: SKLabelNode!
    var timeToLifeLabel: SKLabelNode!
    var initialXPosition: CGFloat?
    var finalXPosition: CGFloat?
    
    override func didMove(to view: SKView) {
        //        Setup your scene here
        
//        Swipeeee!
        /*let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)*/
        
        scrollLayer = self.childNode(withName: "ScrollLayer")
        
        //        Set UI connections
        
        buttonPlay1 = self.childNode(withName: "//buttonPlay1") as! MSButtonNode
        buttonPlay1.selectedHandler = { [unowned self] in
            self.loadGame(level: 1)
        }
        if levelsUnlocked! < 1 {
            buttonPlay1.isHidden = true
        }
        
        buttonPlay2 = self.childNode(withName: "//buttonPlay2") as! MSButtonNode
        buttonPlay2.selectedHandler = { [unowned self] in
            self.loadGame(level: 2)
        }
        if levelsUnlocked! < 2 {
            buttonPlay2.isHidden = true
        }
        
        buttonPlay3 = self.childNode(withName: "//buttonPlay3") as! MSButtonNode
        buttonPlay3.selectedHandler = { [unowned self] in
            self.loadGame(level: 3)
        }
        if levelsUnlocked! < 3 {
            buttonPlay3.isHidden = true
        }
        
        buttonPlay4 = self.childNode(withName: "//buttonPlay4") as! MSButtonNode
        buttonPlay4.selectedHandler = { [unowned self] in
            self.loadGame(level: 4)
        }
        if levelsUnlocked! < 4 {
            buttonPlay4.isHidden = true
        }
        
        buttonPlay5 = self.childNode(withName: "//buttonPlay5") as! MSButtonNode
        buttonPlay5.selectedHandler = { [unowned self] in
            self.loadGame(level: 5)
        }
        if levelsUnlocked! < 5 {
            buttonPlay5.isHidden = true
        }
        
        buttonPlay6 = self.childNode(withName: "//buttonPlay6") as! MSButtonNode
        buttonPlay6.selectedHandler = { [unowned self] in
            self.loadGame(level: 6)
        }
        if levelsUnlocked! < 6 {
            buttonPlay6.isHidden = true
        }
        
        buttonPlay7 = self.childNode(withName: "//buttonPlay7") as! MSButtonNode
        buttonPlay7.selectedHandler = { [unowned self] in
            self.loadGame(level: 7)
        }
        if levelsUnlocked! < 7 {
            buttonPlay7.isHidden = true
        }
        
        addLifeButton = self.childNode(withName: "//addLifeButton") as! MSButtonNode
        addLifeButton.selectedHandler = { [unowned self] in
            self.loadAds()
        }
        
        livesLabel = self.childNode(withName: "livesLabel") as! SKLabelNode
        livesLabel.text = "x \(lives!)"
        
        timeToLifeLabel = self.childNode(withName: "timeToLifeLabel") as! SKLabelNode
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position :CGPoint = touch.location(in: view)
            initialXPosition = position.x
            print("initialPosition = \(initialXPosition!)")
            
        }
    }
    /*func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                swipeRight()
            case UISwipeGestureRecognizerDirection.left:
                swipeLeft()
            default:
                break
            }
        }
    }*/
 
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position :CGPoint = touch.location(in: view)
            finalXPosition = position.x
            print("finalposition = \(finalXPosition!)")
            if scrollLayer.position.x <= 0 && scrollLayer.position.x >= -549 {
            scrollLayer.position.x += finalXPosition! - initialXPosition!
            initialXPosition = finalXPosition
            }
            if scrollLayer.position.x > 0 {
                scrollLayer.position.x = 0
            } else if scrollLayer.position.x < -549 {
                scrollLayer.position.x = -549
            }
        }
    }

    /*func swipeRight() {

//        if scrollLayer.position.x < 0 {
//            scrollLayer.position.x += finalXPosition! - initialXPosition!
//            if scrollLayer.position.x > 0 {
//                scrollLayer.position.x = 0
//            }
//        }
        print("swiped right")
    }
  
    func swipeLeft() {
//        if scrollLayer.position.x > -800 {
//            scrollLayer.position.x += final! - initialXPosition!
//            if scrollLayer.position.x < -800 {
//                scrollLayer.position.x = -800
//            }
//        }
        print("swiped left")
    }*/
 
    override func update(_ currentTime: TimeInterval) {
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
        livesLabel.text = "x \(lives!)"
        
        if counterActive == true {
            var timeInterval = DateComponents()
            timeInterval.minute = 10
            let futureDate = Calendar.current.date(byAdding: timeInterval, to: savedTime!)!
            let timeInSeconds = Int(futureDate.timeIntervalSince(Date()))
            timeToLifeLabel.text = "\(String(format: "%02d" ,((timeInSeconds % 3600) / 60))):\(String(format: "%02d" ,((timeInSeconds % 3600) % 60)))"
        } else {
            timeToLifeLabel.text = "Full"
        }
        //"\(String(format: "%02d", timeInSeconds % 3600) / 60)):\((timeInSeconds % 3600) % 60)"
    }
    
    func loadGame(level: Int) {
        if lives! > 0 {
            //        1) Grab reference to our SpriteKit view
            guard let skView = self.view as SKView! else {
                print ("Could not get SkView")
                return
            }
            
            //        2) Load Game scene
            guard let scene = GameScene(fileNamed:"Level\(level)") else {
                print ("Could not make GameScene")
                return
            }
            
            //        3) Ensure correct aspect mode
            scene.scaleMode = .aspectFit
            
            //        Show debug
            skView.showsPhysics = false
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            //        4) Start game scene
            skView.presentScene(scene)
        }
    }
    
    func loadAds() {
        //        1) Grab reference to our SpriteKit view
        guard let skView = self.view as SKView! else {
            print ("Could not get SkView")
            return
        }
        
        //        2) Load Ads scene
        guard let scene = AdsMenu(fileNamed:"AdsMenu") else {
            print ("Could not make GameScene")
            return
        }
        
        //        3) Ensure correct aspect mode
        scene.scaleMode = .aspectFit
        
        //        Show debug
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        //        4) Start game scene
        skView.presentScene(scene)
    }
}

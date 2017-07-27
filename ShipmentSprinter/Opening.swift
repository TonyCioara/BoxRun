
import SpriteKit

class Opening: SKScene {
    
    var menuTimer: CGFloat = 0
    var labelTimer: CGFloat = 0
    var spawnTimer: CGFloat = 6.8
    let fixedDelta: CFTimeInterval = 1.0/60.0 // 60 FPS
    var boxesSpawned = 0
    var randBox = 0
    var randX = 0
    var spawnTimerTimer: CGFloat = 7
    
    var characterReference: SKSpriteNode!
    var boxReference: SKSpriteNode!
    var character: SKSpriteNode!
    var boxLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        characterReference = childNode(withName: "characterReference") as? SKSpriteNode
        boxReference = childNode(withName: "boxReference") as? SKSpriteNode
        boxLabel = childNode(withName: "boxLabel") as? SKLabelNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        menuTimer += CGFloat(fixedDelta)
        spawnTimer += CGFloat(fixedDelta)
        labelTimer += CGFloat(fixedDelta)
        
        if labelTimer >= 5 {
            boxLabel.alpha += (labelTimer - 5) * 25
        }
        
        if spawnTimer >= spawnTimerTimer && boxesSpawned <= 60 {
            if spawnTimerTimer >= 0.15 {
                spawnTimerTimer = spawnTimerTimer / 2
            }
            boxesSpawned += 1
            spawnTimer = 0
            randBox = Int(arc4random_uniform(2))
            randX = Int(arc4random_uniform(528))
            if randBox == 1 {
                let newObject = characterReference.copy() as! SKSpriteNode
                newObject.position.x = CGFloat(randX + 20)
                newObject.position.y = CGFloat(400)
                self.addChild(newObject)
                print("spawn1")
            } else {
                let newObject = boxReference.copy() as! SKSpriteNode
                newObject.position.x = CGFloat(randX)
                newObject.position.y = CGFloat(400)
                self.addChild(newObject)
                print("spawn2")
            }
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if menuTimer >= 5 {
            loadMainMenu()
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

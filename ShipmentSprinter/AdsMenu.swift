
import SpriteKit
import GoogleMobileAds

class AdsMenu: SKScene, UITextFieldDelegate, GADInterstitialDelegate {
   
    var settingsButton: MSButtonNode!
    var adButton: MSButtonNode!
    var buyButton: MSButtonNode!
    
    var livesLabel: SKLabelNode!
//    var interstitialAd : GADInterstitial!
    
    override func didMove(to view: SKView) {
        settingsButton = self.childNode(withName: "settingsButton") as! MSButtonNode
        settingsButton.selectedHandler = { [unowned self] in
            self.loadMainMenu()
        }
        buyButton = self.childNode(withName: "buyButton") as! MSButtonNode
        buyButton.selectedHandler = { [unowned self] in
            self.buyFunc()
        }
        adButton = self.childNode(withName: "adButton") as! MSButtonNode
        adButton.selectedHandler = { [unowned self] in
            self.adFunc()
        }
        livesLabel = self.childNode(withName: "livesLabel") as! SKLabelNode
        livesLabel.text = "x \(lives!)"
        
//        self.interstitialAd = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
//        let request = GADRequest()
//        request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
//        self.interstitialAd.load(request)
//        self.interstitialAd = reloadInterstitialAd()
    }
    
    func adFunc() {
//        NotificationCenter.default.post !!!!!! ENZO FIREFIGHTER ADS!!!!!!
        lives = lives! + 5
        livesLabel.text = "x \(lives!)"
    }
    
    func buyFunc() {
        
        lives = lives! + 20
        livesLabel.text = "x \(lives!)"
    }
    
    
//    func reloadInterstitialAd() -> GADInterstitial {
//        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
//        interstitial.delegate = self
//        interstitial.load(GADRequest())
//        return interstitial
//    }
//    
//    func interstitialDidDismissScreen(ad: GADInterstitial!) {
//        self.interstitialAd = reloadInterstitialAd()
//    }
//    
//    @IBAction func showAd(sender: AnyObject) {
//        if self.interstitialAd.isReady {
//            self.interstitialAd.present
//        }
//    }
    
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

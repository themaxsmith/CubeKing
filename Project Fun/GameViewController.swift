//
//  GameViewController.swift
//  Project Fun
//
//  Created by Maxwell Smith on 12/23/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //  NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.doaSegue), name: NSNotification.Name(rawValue: "gameover"), object: nil)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                var size = scene.size
                let newHeight = view.bounds.size.height / view.bounds.width * size.width
                
                if newHeight > size.height {
                    scene.anchorPoint = CGPoint(x: 0, y: (newHeight - scene.size.height) / 2.0 / newHeight)
                    size.height = newHeight
                    scene.size = size
                }
                
                
                scene.scaleMode = .aspectFit
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
           // view.showsFPS = true
          //  view.showsNodeCount = true
            if !(Global.global.rAds){
                ad.adUnitID = "google-ad-id"
                ad.rootViewController = self
                ad.load(GADRequest())
            }
        }
    }
    @IBOutlet weak var ad: GADBannerView!
    
    @objc func doaSegue(){
     
      
        performSegue(withIdentifier: "gameover", sender: nil)
         if let view = self.view as! SKView? {
            let x = view.scene as! GameScene
            x.running = false
            x.reset()
            x.players.removeAll()
            x.ConntrolledPlayer = nil
            view.presentScene(nil)
            view.removeFromSuperview()
           
            print("Kill all leftover")
        }
       // self.view = UIView()
       // self.view.removeFromSuperview()
      //  self.view = nil
        NotificationCenter.default.removeObserver(self)
       NotificationCenter.default.removeObserver(self, name:  NSNotification.Name(rawValue: "gameover"), object: nil)
    }
    override var shouldAutorotate: Bool {
        return true
    }
    deinit {
        print("GameController deinit")
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.view.removeFromSuperview()
        //self.view = nil
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

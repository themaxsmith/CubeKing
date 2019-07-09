//
//  MenuViewController.swift
//  CubeKing
//
//  Created by Maxwell Smith on 12/28/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//

import Foundation
import UIKit
import SwiftyStoreKit
import SpriteKit
import GoogleMobileAds
import MultiPeer
class MenuViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func unlockADS(){
        Global.global.rAds = true
        UserDefaults.standard.set(true, forKey: "ads") //Bool
        ad.isHidden = true
        removeAds.isHidden = true
    }
    @IBOutlet weak var removeAds: UIButton!
    @IBOutlet weak var personView: UIView!
    @IBOutlet weak var ad: GADBannerView!
    
    func updateTXT(){
        TXTcoins.text = "\(Global.global.points)"
        TXTKills.text = "\(Global.global.allKills)"
    }
    override func viewDidLoad() {
            //UserDefaults.standard.set(1, forKey: "Key")  //Integer
    
         Global.global.isOnline = false
            var c = randomColor()
        Global.global.playerColor = c
        Skin.skinRandom.color = c
       
        table.reloadData()
            let RemoveAds =  UserDefaults.standard.bool(forKey: "ads")
            Global.global.rAds = RemoveAds
         //Global.global.points = 1000
        Global.global.points =  UserDefaults.standard.integer(forKey: "points")
        
        Global.global.allKills =  UserDefaults.standard.integer(forKey: "kills")
        var skinID =  UserDefaults.standard.integer(forKey: "skin")
        skin(x: skinID)
         Global.global.skin =  skinID
            print("Remove Ads:")
            print(Global.global.rAds)
        if (RemoveAds){
            self.removeAds.isHidden = true
        }
            print("Points:")
            print(Global.global.points)
        updateTXT()
        for x in skins{
              let unlocked =  UserDefaults.standard.bool(forKey: "skin_\(x.id)")
            if (unlocked){
                x.cost = 0
            }
        }
        if !(Global.global.rAds){
        ad.adUnitID = "google-ad-unit-id"
        ad.rootViewController = self
            ad.load(GADRequest())
        }
        if let view = personView as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "DisplayScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
          //  view.backgroundColor = view.scene?.backgroundColor
            
        }
        if (MultiPeer.instance.isConnected){
        MultiPeer.instance.end()
        }
    }
    
    @IBOutlet weak var table: UICollectionView!
    @IBAction func removeAd(_ sender: Any) {
       buyRemove()
    }
    func restore(){
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                self.unlockADS()
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    func purchase(){
        SwiftyStoreKit.purchaseProduct("removeAds", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.unlockADS()
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    func skin(x:Int){
        if let skin = skins.first(where: {$0.id == x}){
        Global.global.playerTexture = nil
        
        Global.global.playerColor = skin.color
                 Global.global.skin =  skin.id
        if (skin.image != nil){
            
            Global.global.playerTexture = SKTexture(image: skin.image!)
        }
        self.table.reloadData()
        }
    }
    func select(_ skin:Skin){
        var canBuy = false
        if skin.isKills {
            if (Global.global.allKills >= skin.cost){
                canBuy = true
            }
        }else{
        if (Global.global.points >= skin.cost){
            canBuy = true
        }
        }
        if (canBuy){
        let alert = UIAlertController(title: "Unlock Skin", message: "Unlock this skin with \(skin.cost) \(skin.isKills ? "Kills" : "Coins")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Unlock Skin", style: .default, handler: { action in
            if !(skin.isKills){
           Global.global.points -= skin.cost
            }
            skin.cost = 0
            UserDefaults.standard.set(true, forKey: "skin_\(skin.id)")  //Integer
            Global.global.playerTexture = nil
              Global.global.skin =  skin.id
            Global.global.playerColor = skin.color
            if (skin.image != nil){
              
                Global.global.playerTexture = SKTexture(image: skin.image!)
            }
            self.table.reloadData()
            self.updateTXT()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Not enough \(skin.isKills ? "Kills" : "Coins")", message: "Please get more \(skin.isKills ? "Kills" : "Coins") to unlock skin", preferredStyle: .alert)
    
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
  
    func buyRemove(){
        let alert = UIAlertController(title: "Ad Options", message: "Remove All Ads", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Remove Ads for $0.99 USD", style: .default, handler: { action in
            self.purchase()
        }))
        alert.addAction(UIAlertAction(title: "Restore Purchase", style: .default, handler: { action in
            self.restore()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skins.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! SkinCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.name.text = skins[indexPath.item].name
       
        if (skins[indexPath.item].cost == 0){
     //   cell.cost.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
             cell.cost.text = ""
        }else{
            if skins[indexPath.item].isKills {
                cell.cost.text = "\(skins[indexPath.item].cost) Kills"
            }else{
             cell.cost.text = "\(skins[indexPath.item].cost) Coins"
                
        }
        }
        if (skins[indexPath.item].id == 0){
       
        }
         cell.name.backgroundColor = #colorLiteral(red: 0.01302453317, green: 0.01302947663, blue: 0.01302388217, alpha: 0.2952964469)
        cell.image.backgroundColor = skins[indexPath.item].color
        cell.image.image = skins[indexPath.item].image
        
        return cell
    }
 
    @IBOutlet weak var TXTKills: UILabel!
    
    @IBOutlet weak var TXTcoins: UILabel!
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if skins[indexPath.item].cost == 0{
        Global.global.playerTexture = nil
        print("You selected cell #\(indexPath.item)!")
             UserDefaults.standard.set(skins[indexPath.item].id, forKey: "skin") //Bool
        Global.global.playerColor = skins[indexPath.item].color
             Global.global.skin = skins[indexPath.item].id
            
        if (skins[indexPath.item].image != nil){
            print(skins[indexPath.item].cost)
        Global.global.playerTexture = SKTexture(image: skins[indexPath.item].image!)
        }
    }else{
    select(skins[indexPath.item])
    }
}
}
var skins = [Skin.skinRandom, Skin.skinBlue, Skin.skinCamo, Skin.skinRoses,Skin.skinDark]

func skin(x:Int)->Skin{
    if let skin = skins.first(where: {$0.id == x}){
        
        return skin
    }
    return Skin.skinRandom
}

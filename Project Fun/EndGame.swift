//
//  EndGame.swift
//  CubeKing
//
//  Created by Maxwell Smith on 12/27/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
class EndGame:UIViewController, GADInterstitialDelegate {
    @IBOutlet weak var ad: GADBannerView!
    @IBOutlet weak var coins: UILabel!
    var interstitial: GADInterstitial!
    var showAd = true
    override func viewWillAppear(_ animated: Bool) {
        if (Global.global.place == 1){
            result.text = "You Won!"
        }else{
            result.text = "You Lost!"
        }
        var p = genScore()
        Global.global.points += p
       showAd = true
        Global.global.allKills += Global.global.kills
        UserDefaults.standard.set(Global.global.points, forKey: "points")
        UserDefaults.standard.set(Global.global.allKills, forKey: "kills")  //Integer
        coins.text = "\(p) Coins"
        placeText.text = "\(Global.global.place.ordinal ?? "") Place"
        kills.text = "\(Global.global.kills) Kill(s)"
        if !(Global.global.rAds){
            ad.adUnitID = "goog-ad-id"
            ad.rootViewController = self
            ad.load(GADRequest())
        
        if (showAd){
            
        interstitial = GADInterstitial(adUnitID: "google-ad-id")
        interstitial.delegate = self
        let request = GADRequest()
       // request.testDevices = [ "kGADSimulatorID" ]
        interstitial.load(request)
        }
        }
    }
    func genScore()->Int{
        var p = Global.global.place
        var points = abs(p - 15) * 2
        if (p == 1){
            points = 50
        }
        points += Global.global.kills * 3
        if Global.global.isOnline{
            points = points / 5
        }
        return points
    }
    @IBAction func `continue`(_ sender: Any) {
        if (showAd){
          if !(Global.global.rAds){
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
            performSegue(withIdentifier: "home", sender: self)
            }}else{
             performSegue(withIdentifier: "home", sender: self)
        }
        }else{
             performSegue(withIdentifier: "home", sender: self)
        }
    }
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
        
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
   // performSegue(withIdentifier: "home", sender: self)
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
        //performSegue(withIdentifier: "home", sender: self)
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        performSegue(withIdentifier: "home", sender: self)
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
        performSegue(withIdentifier: "home", sender: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
       Global.global.play = true
    Global.global.isOnline = false
         Global.global.startServer = false
    }
    @IBOutlet weak var placeText: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var kills: UILabel!
}
private var ordinalFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter
}()

extension Int {
    var ordinal: String? {
        return ordinalFormatter.string(from: NSNumber(value: self))
    }
}

//
//  Global.swift
//  CubeKing
//
//  Created by Maxwell Smith on 12/27/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
class Global {
    
    var isOnline = false
    var kills = 0
    var place = 0
    var points = 0
    var playerColor = UIColor.blue
    var playerTexture:SKTexture?
    var skin:Int = 0
    var allKills = 0
    var play = true
    var addedCoins = 0
    var rAds = false
    var startServer = false
    static let global:Global = Global()
}

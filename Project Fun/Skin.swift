//
//  Skin.swift
//  CubeKing
//
//  Created by Maxwell Smith on 12/29/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//

import Foundation
import UIKit

class Skin {
    var image:UIImage?
    var color:UIColor = .black
    var name:String = ""
    var cost = 0,id = 0
    var isKills = false
    var unlocked = false
    init(_ colorI:UIColor, _ nameI:String, _ costI:Int, _ idI:Int) {
        color = colorI
        cost = costI
        id = idI
        name = nameI
    }
    
    init(_ colorI:UIColor, _ nameI:String, _ costI:Int, _ idI:Int, _ imageI:UIImage) {
        color = colorI
        cost = costI
        id = idI
        name = nameI
        image = imageI
    }
    init(_ colorI:UIColor, _ nameI:String, _ costI:Int, _ idI:Int, _ imageI:UIImage, _ kills:Bool) {
        color = colorI
        cost = costI
        id = idI
        name = nameI
        image = imageI
        isKills = kills
    }
    static let skinRandom = Skin(.blue, "Random", 0, 0)
    static let skinBlue = Skin(.blue, "Blue", 50, 1)
    static let skinCamo = Skin(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), "Camo", 250, 3, UIImage(named: "camo")!)
     static let skinRoses = Skin(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), "Roses", 350, 4, UIImage(named: "roses")!)
   // static let skinPink = Skin(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), "Pink", 300, 5, UIImage(named: "pink")!)
     static let skinDark = Skin(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), "Ultimate", 50, 6, UIImage(named: "dark")!, true)
}



//
//  PlayerData.swift
//  CubeKing
//
//  Created by Maxwell Smith on 12/27/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//

import Foundation
import SpriteKit
class PlayerData {
    let rotation:CGFloat
    let pos:CGPoint
    let id:String
    let scale:CGFloat
    let skin:Int
    init(r:CGFloat, posi:CGPoint, sc:CGFloat, i: String, s:Int) {
        rotation = r
        pos = posi
        id = i
        scale = sc
        skin = s
    }
    func out()->String{
        return "\(rotation)$\(pos.x)$\(pos.y)$\(scale)$\(id)$\(skin)"
    }
    init(_ ins:String) {
        print(ins)
        var x = ins.split(separator: "$")
        rotation = String(x[0]).CGFloatValue()!
        pos = CGPoint(x: String(x[1]).CGFloatValue()!, y: String(x[2]).CGFloatValue()!)
        id = String(x[4])
        skin = Int(x[5]) ?? 0
        scale = String(x[3]).CGFloatValue()!
    }
}
extension String {
    
    func CGFloatValue() -> CGFloat? {
        guard let doubleValue = Double(self) else {
            return nil
        }
        
        return CGFloat(doubleValue)
    }
}

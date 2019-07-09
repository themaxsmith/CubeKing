//
//  Control.swift
//  Project Fun
//
//  Created by Maxwell Smith on 12/25/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//

import Foundation
class Control{
    var isOnline = false
    
    init(_ online:Bool = false) {
        isOnline = online
    }
    
    var oppenets:[Player] = []
    
    
    func update(){
        for x in oppenets {
            x.update()
      
        }
    }
    
    func serverResponse( ){
        
    }
    

}

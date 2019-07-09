//
//  DisplayScene.swift
//  CubeKing
//
//  Created by Maxwell Smith on 12/28/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
class DisplayScene: SKScene{
    var player = Player(x: 0, y: 0)
    override func didMove(to view: SKView) {
        
        //player.zRotation = .pi / 2
        player.xScale = 4
        player.yScale = 4
        player.fillColor = Global.global.playerColor
        player.setTexture()
       // player.fillTexture = Global.global.
        let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 15)
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        
        player.run(repeatRotation)
        self.addChild(player)
    }
    var pastTime:TimeInterval = 0
    var times = 0
    var posX:CGFloat = 0.0
    var posY:CGFloat = 0.0
    var initalPosX:CGFloat = 0.0
    var initalPosY:CGFloat = 0.0
    var angle:CGFloat = 0.0
    
    func touchDown(atPoint pos : CGPoint) {
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        //let distance = abs(self.pos - pos.x)
        if (self.posX - pos.x != 0) || (self.posY - pos.y != 0){
            let distance = sqrt(pow(self.posX - pos.x, 2.0) + pow(self.posY - pos.y, 2.0))
            let moveDuration = 0.0001 * distance;
            var newA =  atan2(pos.y-self.posY,  pos.x - self.posX);
            // redBall.run(SKAction.move(to: CGPoint(x: initalPosX + (pos.x - self.posX), y: initalPosY + (pos.y - self.posY)), duration: TimeInterval(moveDuration)))
            
            
            
            if (newA != angle){
                shoot = false
               player.zRotation = newA
           
            }
        }
        // redBall.physicsBody.a
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    var shoot = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       player.removeAllActions()
            shoot = true
            initalPosX = player.position.x
            posX = (touches.first?.location(in: self).x)!
            initalPosY = player.position.y
            posY = (touches.first?.location(in: self).y)!
            for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
  
            for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
 
            if (shoot){
              player.shootDisplay()
                
                }
                print("shoot")
        let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 15)
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        
        player.run(repeatRotation)
            }
        
        // for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func update(_ currentTime: TimeInterval) {
        
            if currentTime > pastTime {
                pastTime = currentTime + 0.5
                times += 1
                if (times == 1){
              player.shootDisplay()
                }
                if (times == 8){
                    times = 0
                }
                player.fillColor = Global.global.playerColor
                player.setTexture()
            }
}
}

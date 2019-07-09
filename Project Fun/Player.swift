//
//  Player.swift
//  Project Fun
//
//  Created by Maxwell Smith on 12/24/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//

import Foundation
import SpriteKit
class Player: SKShapeNode{
    override init() {
        super.init()
    }
    var type = 0
    var vaild = true
    var reward = false
    var botTiming = 0
    var place = 1
    var onlineID = ""
      var botTiming2 = 0
    var kills = 0
    weak var lastHitBy: Player?
    convenience init(x:Int, y:Int) {
     
        self.init(rect: CGRect(x: -10, y: -10, width: 20, height: 20))
        
      
        let x = SKShapeNode(circleOfRadius: 2)
        x.fillColor = .black
         x.zPosition = 1
        x.position = CGPoint(x: 10, y: 0)
        addChild(x)
       randomSkin()
      //  position = CGPoint(x: x, y: 320)
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
      physicsBody?.restitution = 0.75
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = true
       // physicsBody?.collisionBitMask = groundCat
        physicsBody?.contactTestBitMask = groundCat
        xScale = 1.3
        yScale = 1.3
        
        
  
        //physicsBody?.categoryBitMask = redBallCat
    }
    var t:SKSpriteNode?
    func setTexture(){
        if (t != nil){
        t?.removeFromParent()
        }
        t = SKSpriteNode(texture: Global.global.playerTexture, color: .clear, size: CGSize(width: 20, height: 20))
       
        addChild(t!)
    }
    func setTexture(_ text:SKTexture){
        if (t != nil){
            t?.removeFromParent()
        }
        t = SKSpriteNode(texture: text, color: .clear, size: CGSize(width: 20, height: 20))
        
        addChild(t!)
    }
    func randomSkin(){
          let x = Int.random(in: 0..<10)
        var skin:Skin?
        switch x {
        case 1:
            skin = Skin.skinCamo
        case 2:
            skin = Skin.skinRoses
        case 3:
            skin = Skin.skinDark
        default:
            fillColor = randomColor()
        }
        if skin != nil {
        fillColor = (skin?.color)!
        if (skin?.image != nil){
            setTexture(SKTexture(image: (skin?.image)!))
        }
        }
    }
    func setSkin(_ skin:Skin){
    
        if skin.id == 0{
            fillColor = randomColor()
        }else{
            fillColor = (skin.color)
            if (skin.image != nil){
                setTexture(SKTexture(image: (skin.image)!))
            }
        }
    }
    var isBeingBounced = false
    func addArrow(){
        let arrow = SKSpriteNode(texture: SKTexture(imageNamed: "arrow"), size: CGSize(width: 20, height: 20))
        arrow.position = CGPoint(x: 10, y: 0)
        arrow.zRotation =  -(.pi / 2)
        arrow.anchorPoint = CGPoint(x: 0.5, y: 0)
        arrow.zPosition = -1
        arrow.alpha = 0.2
        addChild(arrow)
    }
    func gained(){
        xScale += 0.1
        yScale += 0.1
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func killed(_ x:Player){
       
            xScale += 0.2
            yScale += 0.2
        kills = kills + 1
    }
    func update(){
     
        let r:CGFloat = 7
        
        let dx = r * cos(zRotation)
        let dy = r * sin(zRotation)

 

        run(SKAction.move(by: CGVector(dx: dx, dy: dy), duration: 0.1), withKey: "input")
    }
    func projection(){
        let r:CGFloat = 200
        
        let dx = r * cos(zRotation)
        let dy = r * sin(zRotation)
        intent = CGPoint(x: dx+position.x, y: dy+position.y)
    }
    func getBullets()->Int{
        return Int((((xScale) - 1) * 10).rounded())
    }
    func findNearby(players:[Player])->Bool{
        var power:CGFloat = 200.0
        var found = false
        for o in players {
            if (o != self){
                let distance = sqrt(pow(position.x - o.position.x, 2.0) + pow(position.y - o.position.y, 2.0))
                if (power > distance){
                    power = distance
                    self.intent = CGPoint(x: o.position.x, y: o.position.y)
                    self.intentPlayer = o
                    //print("FOUND POSSIBLE")
                    found = true
                }
            }
            
        }
        return found
    }
    func highlight(){
    //   strokeColor =
    }
    func shoot()->Bool{
        if (xScale > 1){
        let bullet1 = Bullet(circleOfRadius: 2)
        bullet1.name = "Bullet"
        bullet1.owner = self
        
        bullet1.position = CGPoint(x: position.x, y: position.y)
        bullet1.zRotation = CGFloat(zRotation)
        bullet1.physicsBody = SKPhysicsBody(circleOfRadius: 2)
        bullet1.physicsBody!.affectedByGravity = false
        bullet1.physicsBody!.categoryBitMask = bulletCat
        //bullet1.physicsBody!.collisionBitMask = PhysicsCategories.none
        bullet1.physicsBody!.contactTestBitMask = groundCat
        parent?.addChild(bullet1)
        let distance:CGFloat = 500.0
        let moveBullet1 = SKAction.move(to: CGPoint(
            x: distance * cos(bullet1.zRotation) + bullet1.position.x,
            y: distance * sin(bullet1.zRotation) + bullet1.position.y),
                                        duration: 1)
        let deleteBullet1 = SKAction.removeFromParent()
        
        let bullet1Sequence = SKAction.sequence([moveBullet1, deleteBullet1])
        
        bullet1.run(bullet1Sequence)
            xScale -= 0.1
            yScale -= 0.1
            return true
        }else{
            print(xScale)
            return false
        }
    }
    func shootDisplay(){
       
            let bullet1 = Bullet(circleOfRadius: 2)
            bullet1.name = "Bullet"
            bullet1.owner = self
            bullet1.position = CGPoint(x: position.x, y: position.y)
            bullet1.zRotation = CGFloat(zRotation)
            bullet1.zPosition = -1
            parent?.addChild(bullet1)
            let distance:CGFloat = 500.0
            let moveBullet1 = SKAction.move(to: CGPoint(
                x: distance * cos(bullet1.zRotation) + bullet1.position.x,
                y: distance * sin(bullet1.zRotation) + bullet1.position.y),
                                            duration: 1)
            let deleteBullet1 = SKAction.removeFromParent()
            
            let bullet1Sequence = SKAction.sequence([moveBullet1, deleteBullet1])
            
            bullet1.run(bullet1Sequence)
       
    
    }
    var intent:CGPoint? = nil
    var state:Int = 0
    weak var intentPlayer:Player? = nil
    deinit {
        print("Player deinit")
    }
}
  


extension SKShapeNode{
    func getDistance(_ o:SKShapeNode)-> CGFloat {
    return sqrt(pow(position.x - o.position.x, 2.0) + pow(position.y - o.position.y, 2.0))
}
    func faceTowards(_ o:SKShapeNode){
        zRotation =  atan2(o.position.y-position.y,  o.position.x - position.x);
    }
    func faceTowardsBot(_ o:SKShapeNode){
         let r = CGFloat(Double.random(in: (-0.288)..<(0.288)))
        zRotation =  atan2(o.position.y-position.y,  o.position.x - position.x) + r ;
    }
}



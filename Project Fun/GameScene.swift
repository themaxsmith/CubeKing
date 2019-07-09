//
//  GameScene.swift
//  Project Fun
//
//  Created by Maxwell Smith on 12/23/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//

import SpriteKit
import GameplayKit
import MultiPeer
class GameScene: SKScene, SKPhysicsContactDelegate {
    

    var lastOnStanding: SKLabelNode!
    var kills: SKLabelNode!
    var bullets: SKLabelNode!
    var ready: SKLabelNode!
    var running = false
    weak var ConntrolledPlayer:Player!
    
    var host = true
    
    var players:[Player] = []
    
       var ground = SKShapeNode(ellipseIn: CGRect(x: -220, y: -390, width: 440, height: 780))
    var orbLoc:[CGPoint] = []
    func setup2(){
        if !(isOnline){
            var enemy = 0
            while (enemy < 14)
            {
                
                let enemy2:Player = Player(x: 200, y: 400)
                enemy2.type = 1
                addPlayer(player: enemy2)
                enemy += 1
                
            }
        }
    }
    func setup(){
       
  
        let user = Player(x: 200, y: 400)
        addPlayer(player: user)
        ConntrolledPlayer = user
        user.addArrow()
        user.highlight()
        user.onlineID = randomString(length: 20)
        user.fillColor = Global.global.playerColor
        user.setTexture()
        if (isOnline){
        sendPlayer()
        }
        var orbs = 0
        
    
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.position = CGPoint(x: 240, y: 400)
        ground.strokeColor = .red
        ground.fillColor = .darkGray
        ground.zPosition = -1
        self.addChild(ground)
        
        while (orbs < 30)
        {
            var radius:CGFloat = 3.0
            let y = Int.random(in: 0..<800)
            let x = Int.random(in: 0..<480)
            if (ground.contains(CGPoint(x: x, y: y))){
                let orb = SKShapeNode(circleOfRadius: radius)
                orb.fillColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                orbLoc.append(CGPoint(x: x, y: y))
                orb.position = CGPoint(x: x, y: y)
                orb.physicsBody = SKPhysicsBody(circleOfRadius: radius)
                orb.physicsBody?.contactTestBitMask = groundCat
                orb.physicsBody?.categoryBitMask = redBallCat
                orb.physicsBody?.affectedByGravity = false
                self.addChild(orb)
                orbs += 1
            }
        }
        
        
        ground.physicsBody?.categoryBitMask = groundCat
    }
    func start(){
        running = true
           ground.run(SKAction.scale(to: 0.2, duration: 35))
    }
    func won(){
         ConntrolledPlayer.place = 1
        reset()
    }
    func reset(){
        if (running){
           
       
                if (isOnline){
                    sendPlayer(DataType.kill)
                }
                
            if (Global.global.isOnline){
                //Global.global.isOnline = true
                connectionHandler.ConnectionManager.game = nil
                MultiPeer.instance.disconnect()
            }
            if (Global.global.play){
                if (ConntrolledPlayer == nil){
                    
                    Global.global.play = false
                }else{
        Global.global.kills = ConntrolledPlayer.kills
        Global.global.place = ConntrolledPlayer.place
                Global.global.play = false
                }
            }else{
                
            }
        running = false
        for x in players{
            x.vaild = false
            x.intentPlayer = nil
            x.lastHitBy = nil
            x.type = 0
            x.removeAllActions()
            x.removeAllChildren()
            x.removeFromParent()
        }
        players = []
        orbLoc = []
            removeAllActions()
            removeAllChildren()
            removeFromParent()
       //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gameover"), object: nil)
            weak var v = (self.view!.window?.rootViewController!.topMostViewController() as! GameViewController)
           
            v?.performSegue(withIdentifier: "gameover", sender: nil)
            //(v?.view as? SKView)?.presentScene(nil)
        print("KILLING")
        }else{
            print("already shutdown")
        }
    }
    func reset2(){
        for x in players{
            x.removeFromParent()
        }
        ground.run(SKAction.scale(to: 0.00001, duration: 1))
        ground.removeFromParent()
        ground = SKShapeNode(ellipseIn: CGRect(x: -220, y: -390, width: 440, height: 780))
        setup()
        start()
        
    }
    var xSpawn = [240,200,260,300,160,140,100,340] // 5 8
    var ySpawn = [400,440,480,520,360,320,280,560,620,240,200,160] // 7 12
    func addPlayer(player:Player){
        var finding = true
        while (finding)
        {
            var radius:CGFloat = 3.0
            let y = Int.random(in: 0..<11)
            let x = Int.random(in: 0..<7)
            var location = CGPoint(x: xSpawn[x], y: ySpawn[y])
           
                player.position = location
            player.botTiming = Int.random(in: 0..<10)
            player.botTiming2 = Int.random(in: 0..<10)
              print("create player \(x) \(y)")
                players.append(player)
            
                self.addChild(player)
                 player.position = location
                finding = false
            
        }
        
    }
    func getPlayer(z:PlayerData)->Player{
        let p = players.filter { $0.onlineID == z.id }.first
        if p != nil {
            return p!
        }else{
            let p = Player(x: 200, y: 200)
           addPlayer(player: p)
            p.setSkin(skin(x: z.skin))
           print("Set skin \(z.skin)")
            p.onlineID = z.id
        return p
        }
    }
    func updatePlayer(z:PlayerData){
        let p = getPlayer(z:z)
        p.type = 10
        
        if ( p.zRotation != z.rotation){
            if (abs(p.position.x - z.pos.x) > 3) &&  (abs(p.position.x - z.pos.x) > 3) {
            print("diference: x \(p.position.x - z.pos.x) y \(p.position.y - z.pos.y) ")
             p.position = z.pos
            p.run(SKAction.move(to: z.pos, duration: 0.01))
            }
             p.zRotation = z.rotation
        }
        p.xScale = z.scale
        p.yScale = z.scale
    }
    func shootPlayer(z:PlayerData){
        let p = getPlayer(z: z)
        p.type = 10
        
        if ( p.zRotation != z.rotation){
            p.position = z.pos
            p.zRotation = z.rotation
        }
        p.xScale = z.scale
        p.yScale = z.scale
        p.shoot()
    }
    func killPlayer(z:PlayerData){
         let p = getPlayer(z: z)
        p.place = players.count
        p.vaild = false
        
        if (p.lastHitBy != nil){
            p.lastHitBy!.killed(p)
            if (ConntrolledPlayer != nil){
                bullets.text = "\(ConntrolledPlayer.getBullets())"
            }
        }
      
        p.removeFromParent()
    }
    func sendPlayer(){
       MultiPeer.instance.stopSearching()
        MultiPeer.instance.send(object: PlayerData(r: ConntrolledPlayer.zRotation, posi: ConntrolledPlayer.position, sc: ConntrolledPlayer.xScale, i: ConntrolledPlayer.onlineID,s:Global.global.skin).out(), type: DataType.player.rawValue)
    }
    func sendPlayer(_ xt:DataType){
        MultiPeer.instance.stopSearching()
        MultiPeer.instance.send(object: PlayerData(r: ConntrolledPlayer.zRotation, posi: ConntrolledPlayer.position, sc: ConntrolledPlayer.xScale, i: ConntrolledPlayer.onlineID,s:Global.global.skin).out(), type: xt.rawValue)
    }


    override func didMove(to view: SKView) {
  
       lastOnStanding = self.childNode(withName: "//last") as? SKLabelNode
          bullets = self.childNode(withName: "//bullets") as? SKLabelNode
        kills = self.childNode(withName: "//kills") as? SKLabelNode
         ready = self.childNode(withName: "//ready") as? SKLabelNode
       // lastOnStanding.text = "Test"
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    
        if (Global.global.isOnline){
            isOnline = true
            
            connectionHandler.ConnectionManager.game = self
        }
  
       setup()
        ready.text = "Ready"
        if (isOnline){
            sendPlayer()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [weak self] in
            self?.ready.text = "Set"
            if ((self?.isOnline)!){
                self?.sendPlayer()
            }
                self?.setup2()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { [weak self] in
            self?.ready.text = "Survive!"
            if ((self?.isOnline)!){
                               self?.sendPlayer()
            }
            self?.start()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: { [weak self] in
            self?.ready.text = ""
       
        })
        
        
        
       
        if !(Global.global.play){
            running = false
            reset()
        }else{
         
        }
    }
    

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
        ConntrolledPlayer.zRotation = newA
                if (isOnline){
        sendPlayer()
                }
            }
        }
       // redBall.physicsBody.a
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    var shoot = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        shoot = true
        initalPosX = ConntrolledPlayer.position.x
        posX = (touches.first?.location(in: self).x)!
        initalPosY = ConntrolledPlayer.position.y
        posY = (touches.first?.location(in: self).y)!
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        
            if (isOnline){
                sendPlayer()
            }
        if (shoot) && running{
            if ConntrolledPlayer.shoot(){
                if (isOnline){
                    sendPlayer(DataType.shoot)
                }
            bullets.text = "\(ConntrolledPlayer.getBullets())"
            }else{
                self.childNode(withName: "//noB")?.removeAllActions()
                self.childNode(withName: "//noBL")?.removeAllActions()
                self.childNode(withName: "//noB")?.alpha = 0.4
                self.childNode(withName: "//noBL")?.alpha = 1
               let fade = SKAction.fadeOut(withDuration: 1)
                 self.childNode(withName: "//noB")?.run(fade)
                       self.childNode(withName: "//noBL")?.run(fade)
            }
          print("shoot")
        }
        
       // for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       // for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func isInsideOfOrOnBorderOfEllipse(p:CGPoint)->Bool{
        
        return ((p.x-ground.position.x)/(193600.0)) + ((p.y-ground.position.y)/(608400.0)) <= 1
    }
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        /// Player with Orb
        if (firstBody.categoryBitMask == 4) && (secondBody.categoryBitMask == 4294967295) {
            
            ///Player hit orb, remove Orb
            
      
            
                 if let secound: Player = secondBody.node as? Player {
                    if (secound.type != 10){
            secound.place = players.count
            secound.vaild = false
            
                    if (secound.lastHitBy != nil) && !secound.reward{
                        secound.reward = true
                        secound.lastHitBy!.killed(secound)
                        if (ConntrolledPlayer != nil){
                           bullets.text = "\(ConntrolledPlayer.getBullets())"
                        }
                    }
                    if (secound == ConntrolledPlayer){
                        reset()
                    }
            secondBody.node?.removeFromParent()
                    }
            }
                    
        }else{
            
            if (firstBody.categoryBitMask == 4294967295) && (secondBody.categoryBitMask == 4294967295) {
                if running{
              contactTwoPlayers(firstBody: firstBody, secondBody: secondBody)
                }
            }else{
                if (firstBody.categoryBitMask == 1) && (secondBody.categoryBitMask == 4) {
                    
                    ///Player hit orb, remove Orb
                    for i in 0..<orbLoc.count{
                        if (orbLoc[i].x == firstBody.node?.position.x){
                            if (orbLoc[i].y == firstBody.node?.position.y){
                                orbLoc.remove(at: i)
                                break
                            }
                        }
                    }
                    

                    firstBody.node?.removeFromParent()
                }else{
                    if (firstBody.categoryBitMask == 1) && (secondBody.categoryBitMask == 4294967295) {
                        
                        ///Player hit orb, remove Orb
                        for i in 0..<orbLoc.count{
                            if (orbLoc[i].x == firstBody.node?.position.x){
                                if (orbLoc[i].y == firstBody.node?.position.y){
                                    orbLoc.remove(at: i)
                                    break
                                }
                            }
                        }
                        firstBody.node?.removeFromParent()
                          let secound: Player = secondBody.node as! Player
                        secound.gained()
                        secound.intent = nil
                           bullets.text = "\(ConntrolledPlayer.getBullets())"
                    }else{
                        if (firstBody.categoryBitMask == 8) && (secondBody.categoryBitMask == 4294967295) {
                        contactPlayerBullet(firstBody: firstBody, secondBody: secondBody)
                        }else{
                             if (firstBody.categoryBitMask == 4) && (secondBody.categoryBitMask == 8) {
                                contactWallBullet(firstBody: firstBody, secondBody: secondBody)
                             }else{
                                   print("A: \(firstBody.categoryBitMask) B: \(secondBody.categoryBitMask)")
                            }
                        }
                     
                        
                        
                    }
           
                }
                
            }
        }
        
       
    }
    var pastTime:TimeInterval = 0
    var times = 0
    var pastForce:CGVector = CGVector(dx: 0, dy: 0)
    
    override func update(_ currentTime: TimeInterval) {
        if (running){
        if currentTime > pastTime {
          pastTime = currentTime + 0.1
      
            for x in players {
                if (!isOnline && x.type == 1){
                bot(x)
                }
                 x.update()
                if (times == x.botTiming){
                    //print("location \(x.position.x) \(x.position.y) \(x.vaild) \(x.parent == nil)")
                    if !(ground.contains(x.position)){
                        x.removeFromParent()
                    
                        x.vaild = false
                    }
                   
                   
                }
            }
       
            //players.update()
            
            times += 1
            if (times == 1){
                if (ConntrolledPlayer != nil){
                    Global.global.kills = ConntrolledPlayer.kills
                    Global.global.place = ConntrolledPlayer.place
                  //  reset()
                }
              players =  players.filter {$0.parent != nil}
                players =  players.filter {$0.vaild != false}
            lastOnStanding.text = "\(players.count)"
                if (ConntrolledPlayer == nil){
                    Global.global.place = players.count + 1
                    reset()
                }else{
                kills.text = "\(ConntrolledPlayer.kills)"
                bullets.text = "\(ConntrolledPlayer.getBullets())"
                }
                if (players.count < 2){
                    reset()
                    print("Should reset")
                }
            }
            
            if (times > 9){
                
                times = 0
              
            }
        }
        }else{
            
        }
    }

    deinit {
        print("Scene deinit")
    }
    
    var isOnline = false
    

    func bot(_ p:Player)  {
        
        switch p.state {
        case 0:
             if (times % 2 == 0){
            p.state = 1
            var seeking = true
                var tries = 0
            while (seeking){
                if (tries > 15){
                    seeking = false
                }
            var r = CGFloat(Double.random(in: (-.pi)..<(.pi)))
            print("BOT: create new direction: \(r)")
            p.zRotation = r
                
            p.projection()
            if (ground.contains(p.intent!)){
               seeking = false
            }
                tries = tries + 1
            }
             }
            break
        case 1:
            if (times == p.botTiming){
                if (p.findNearby(players: players)){
                    p.state = 3
                }else{
                p.projection()
                if (p.intent == nil || !ground.contains(p.intent!)){
                p.state = 0
                    print("BOT: find new path")
                }else{
                    print("BOT: direction okay")
                }
            }
            }
            break
        case 2:
       
            break
        case 3:
            
             if (times == p.botTiming) || (times == p.botTiming2){
             p.state = 1
             }
             if (times % 2 == 0){
                if (p.intentPlayer != nil && (p.intentPlayer?.vaild)!) && p.vaild{
                if p.getDistance(p.intentPlayer!) < 120.0 {
                    if (Int.random(in: 0..<10) > 1){
                    p.faceTowardsBot(p.intentPlayer!)
                    print("BOT: ATTACK")
                    }
                }else{
                    p.faceTowardsBot(p.intentPlayer!)
                    p.shoot()
                    p.state = 0
                    print("BOT: RESET")
                }
            }else{
                p.state = 0
                 print("BOT: RESET 2")
            }
             }
            break
        default:
            print("unkown state")
        }
    }
    func contactTwoPlayers(firstBody: SKPhysicsBody,secondBody: SKPhysicsBody){
        if let first: Player = firstBody.node as? Player {
            if let secound: Player = secondBody.node as? Player {
                
                
                let aR = atan2(first.position.y - secound.position.y,  first.position.x - secound.position.x)
                let bR = atan2(secound.position.y - first.position.y,  secound.position.x - first.position.x)
                var r:CGFloat = 40
                var r2:CGFloat = 40
            
                let closeA = abs(aR-secound.zRotation)
                let closeB = abs(bR-first.zRotation)
                if closeA > closeB{
                    //secound.fillColor = .blue
                    // first.fillColor = .green
                    if (closeB > 0.8){
                        r = 15
                        r2 = 15
                    }
                    r = r * 0.3
                    r2 = r2 * (first.xScale * 1.6)
                    secound.lastHitBy = first
                }else{
                    // secound.fillColor = .green
                    //first.fillColor = .blue
                    if (closeA > 0.8){
                        r = 15
                        r2 = 15
                    }
                    r2 = r2 * 0.3
                    r = r * first.yScale * 1.6
                    first.lastHitBy = secound
                }
                
             
                let dx = r * cos(aR)
                let dy = r * sin(aR)
                
                first.removeAllActions()
              
                first.isBeingBounced = true
                first.run(SKAction.moveBy(x: dx, y: dy, duration: 0.15), completion: {
                    first.isBeingBounced = false
                    
                })
                
                
                let dx2 = r2 * cos(bR)
                let dy2 = r2 * sin(bR)
                
                secound.removeAllActions()
              
                secound.run(SKAction.moveBy(x: dx2, y: dy2, duration: 0.15), completion: {
                    secound.isBeingBounced = false
                    
                })
            
            
                
            }
        }
    }
  func contactPlayerBullet(firstBody: SKPhysicsBody,secondBody: SKPhysicsBody){
        if let first: Bullet = firstBody.node as? Bullet {
        if let secound: Player = secondBody.node as? Player {
            
            if (first.owner != secound){
            let aR = atan2(first.position.y - secound.position.y,  first.position.x - secound.position.x)
            let bR = first.zRotation
            var r:CGFloat = 60
            var r2:CGFloat = 60
           
                //secound.fillColor = .blue
                // first.fillColor = .green
            
                r2 = r2 * first.xScale
            //    secound.lastHitBy = first
            
            
            
            
            
            let dx2 = r2 * cos(bR)
            let dy2 = r2 * sin(bR)
            
            secound.removeAllActions()
            secound.run(SKAction.moveBy(x: dx2, y: dy2, duration: 0.2))
            first.removeFromParent()
                if (first.owner != nil){
                secound.lastHitBy  = first.owner
                }
            }
    }
    }
    }
    func contactWallBullet(firstBody: SKPhysicsBody,secondBody: SKPhysicsBody){
        secondBody.node?.removeFromParent()
    }
}
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
 
}
var redBallCat:UInt32 = 0x1 << 0
var blueBallCat:UInt32 = 0x1 << 1
var groundCat:UInt32 = 0x1 << 2
var bulletCat:UInt32 = 0x1 << 3
func randomColor() -> UIColor {
    let random = {CGFloat(arc4random_uniform(255)) / 255.0}
    return UIColor(red: random(), green: random(), blue: random(), alpha: 1)
}


extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
extension UIColor{
    
    var brightnessAdjustedColor:UIColor{
        
        var components = self.cgColor.components
        let alpha = components?.last
        components?.removeLast()
        let color = CGFloat(1-(components?.max())! >= 0.5 ? 1.0 : 0.0)
        return UIColor(red: color, green: color, blue: color, alpha: alpha!)
    }
}

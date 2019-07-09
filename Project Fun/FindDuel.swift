//
//  FindDuel.swift
//  CubeKing
//
//  Created by Maxwell Smith on 12/26/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//


import UIKit
import SpriteKit
import GameplayKit
import MultiPeer
enum DataType: UInt32 {
    case message = 1
    case start = 2
    case player = 3
    case running = 4
    case kill = 5
    case shoot = 6
    case canSee = 7
}
class connectionHandler:  MultiPeerDelegate {

    weak var waitingPage:SeekFriends?
     weak var game:GameScene?
static let ConnectionManager:connectionHandler = connectionHandler()
    func start() {
       
        MultiPeer.instance.delegate = self
        
        MultiPeer.instance.initialize(serviceType: "cube-king")
        MultiPeer.instance.autoConnect()
      
    }
    func end() {
        MultiPeer.instance.disconnect()
 
    }
    @IBAction func start(_ sender: Any) {
        MultiPeer.instance.stopSearching()
        
        defer {
            MultiPeer.instance.autoConnect()
        }
        
      
            MultiPeer.instance.send(object: "hello \(Int.random(in:  0..<6))", type: DataType.message.rawValue)
   
    }
    

    
    func multiPeer(didReceiveData data: Data, ofType type: UInt32) {
        switch type {
        case DataType.message.rawValue:
            MultiPeer.instance.stopSearching()
          
            guard let message = data.convert() as? String else { return }
            //textField.text = message
            print("rec: \(message) \( MultiPeer.instance.connectedDeviceNames)")
           
            break
            
        case DataType.player.rawValue:
            guard let player = data.convert() as? String else { return }
            if let g = game {
                g.updatePlayer(z: PlayerData(player))
            }
            break
        case DataType.shoot.rawValue:
            guard let player = data.convert() as? String else { return }
            if let g = game {
                g.shootPlayer(z: PlayerData(player))
            }
            break
        case DataType.kill.rawValue:
            guard let player = data.convert() as? String else { return }
            if let g = game {
                g.killPlayer(z: PlayerData(player))
            }
            break
        case DataType.running.rawValue:
            if let g = game {
                g.running = true
            }
            break
        case DataType.start.rawValue:
            if let g = waitingPage {
                g.start()
            }
            break
      
        default:
            break
        }
    }
    
    func multiPeer(connectedDevicesChanged devices: [String]) {
        if (waitingPage != nil){
            if devices.count > 0{
                MultiPeer.instance.stopAccepting()
                
            }else{
                MultiPeer.instance.startAccepting()
               
            }
        }
            if (game != nil){
                waitingPage = nil
                game?.won()
                print("should win")
            }else{
                print("game is null")
            }
            waitingPage?.updatePlayers()
        
    
        print("Connected devices changed: \(devices)")
    }
}
func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
}




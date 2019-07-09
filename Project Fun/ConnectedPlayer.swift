//
//  ConnectedPlayer.swift
//  CubeKing
//
//  Created by Maxwell Smith on 12/26/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//

import Foundation
import MultipeerConnectivity
private let myName = UIDevice.current.name
class ConnectedPlayer {
    var name = "User"
    init(peer: MCPeerID) {
        name = peer.displayName
    }
    init(name: String) {
        self.name = name
    }
    static func getMe() -> ConnectedPlayer {
        return ConnectedPlayer(name: myName)
    }
}

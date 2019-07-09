//
//  PlayerCell.swift
//  CubeKing
//
//  Created by Maxwell Smith on 12/26/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//

//
import UIKit
import Cartography

final class PlayerCell: UICollectionViewCell {
    
    class var reuseID: String { return "PlayerCell" }
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLabel() {
        // Label
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.font = .boldSystemFont(ofSize: 22)
        
        // Layout
        constrain(label) { label in
            label.edges == inset(label.superview!.edges, 15, 10)
        }
    }
}

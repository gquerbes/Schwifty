//
//  FallingObject.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 7/25/16.
//  Copyright © 2016 Fourteen66. All rights reserved.
//

import Foundation
import SpriteKit

class FallingObject: SKSpriteNode{
    
    //    let powerUp = SKSpriteNode(imageNamed: "object1")
    let bitMasks = PhysicsBitMasks()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: String){
        let texture : SKTexture
        let categoryBitMask : UInt32
        switch type{
        case "PowerUp":
            texture = SKTexture(imageNamed: "object4")
            categoryBitMask = bitMasks.powerUp
        case "Obstacle":
            texture = SKTexture(imageNamed: "object5")
            categoryBitMask = bitMasks.obstacle
        case "Bonus":
            texture = SKTexture(imageNamed: "object6")
            categoryBitMask = bitMasks.bonus
        default:
            fatalError("Invalid texture")
        }
        
        super.init(texture: texture, color: SKColor.clear(), size: texture.size())
        
        physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width/2)
        
        physicsBody?.restitution = 0.5
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.collisionBitMask =  bitMasks.walls
        physicsBody?.contactTestBitMask = bitMasks.floor
    }

    
    
}

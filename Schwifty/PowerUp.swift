//
//  PowerUp.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 7/5/16.
//  Copyright © 2016 Fourteen66. All rights reserved.
//

import SpriteKit

class PowerUp:SKSpriteNode{
    
//    let powerUp = SKSpriteNode(imageNamed: "object1")
    let bitMasks = PhysicsBitMasks()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(){
        let texture = SKTexture(imageNamed: "object4")
        super.init(texture: texture, color: SKColor.clear(), size: texture.size())
        
        physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width/2)
        
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = bitMasks.powerUp
        physicsBody?.contactTestBitMask = bitMasks.floor
    }


    
}

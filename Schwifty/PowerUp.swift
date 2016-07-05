//
//  PowerUp.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 7/5/16.
//  Copyright © 2016 Fourteen66. All rights reserved.
//

import SpriteKit

class PowerUp{
    
    let powerUp = SKSpriteNode(imageNamed: "object1")
    let bitMasks = PhysicsBitMasks()
    
    init(){
        powerUp.physicsBody = SKPhysicsBody(circleOfRadius: powerUp.size.width/2)
        powerUp.physicsBody?.affectedByGravity = true
        powerUp.physicsBody?.categoryBitMask = bitMasks.powerUp
    }


    func getPowerUp() -> SKSpriteNode{
        return powerUp
    }
}
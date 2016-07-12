//
//  Paddle.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 7/4/16.
//  Copyright © 2016 Fourteen66. All rights reserved.
//

import Foundation
import SpriteKit

class Paddle:SKSpriteNode  {


    let bitMasks = PhysicsBitMasks()


    
    init(width: CGFloat, height: CGFloat){
//      configurePaddle()
        //declare texture for paddle
        let texture = SKTexture(imageNamed: "paddle_2_100x100")
        //set texture, color and size
        super.init(texture: texture, color: SKColor.clear(), size: CGSize(width: width, height: height))
        
        
        
        //set physics body of paddle
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        
        
        
        //category for paddle
        physicsBody?.categoryBitMask = bitMasks.paddle
        //sprites that collisons will trigger event
        physicsBody?.contactTestBitMask =  bitMasks.powerUp | bitMasks.obstacle
        //sprites that will physically react to collision
        physicsBody?.collisionBitMask = bitMasks.walls
        
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

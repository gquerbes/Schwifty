//
//  Paddle.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 7/4/16.
//  Copyright © 2016 Fourteen66. All rights reserved.
//

import Foundation
import SpriteKit

class Paddle  {

    var paddle:SKSpriteNode!
    var paddleWidth:CGFloat = 40
    var paddleHeight: CGFloat = 40
    
    struct PhysicsCategory {
        static let none : UInt32 = 0
        static let all : UInt32 = UInt32.max
        static let paddle : UInt32 = 0x1     // 1
        static let obstacle : UInt32 = 0x1 << 1      // 2
        static let powerUp : UInt32 = 0x1 << 2    // 4
        static let walls : UInt32 = 0x1 << 3
    }
    
    
    
    func configurePaddle(){
        paddle = SKSpriteNode(imageNamed: "paddle_100x100")
        //set physics body of paddle
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: paddleWidth, height: paddleHeight))
        
        //set physical size of paddle
        paddle.size.width = paddleWidth
        paddle.size.height = paddleHeight
        
        //category for paddle
        paddle.physicsBody?.categoryBitMask = PhysicsCategory.paddle
        //sprites that collisons will trigger event
        paddle.physicsBody?.contactTestBitMask =  PhysicsCategory.powerUp | PhysicsCategory.obstacle
        //sprites that will physically react to collision
        paddle.physicsBody?.collisionBitMask = PhysicsCategory.walls
        
        paddle.physicsBody?.affectedByGravity = false
        paddle.physicsBody?.dynamic = true
        paddle.physicsBody?.allowsRotation = false
    }
    
    func increasePaddleSize(){
        paddleWidth+=20
    }
    
    func decreasePaddleSize(){
        paddleWidth-=20
    }
    
    func getPaddle() -> SKSpriteNode {
        configurePaddle()
        return paddle
    }
    

}
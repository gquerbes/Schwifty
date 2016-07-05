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
    let bitMasks = PhysicsBitMasks()

    
    init(){
      configurePaddle()
    }
    
    func increasePaddleSize(){
        paddleWidth+=20
    }
    
    func decreasePaddleSize(){
        paddleWidth-=20
    }
    
    func configurePaddle(){
        paddle = SKSpriteNode(imageNamed: "paddle_100x100")
        //set physics body of paddle
        
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: paddleWidth, height: paddleHeight))
        
        //set physical size of paddle
        paddle.size.width = paddleWidth
        paddle.size.height = paddleHeight
        
        //category for paddle
        paddle.physicsBody?.categoryBitMask = bitMasks.paddle
        //sprites that collisons will trigger event
        paddle.physicsBody?.contactTestBitMask =  bitMasks.powerUp | bitMasks.obstacle
        //sprites that will physically react to collision
        paddle.physicsBody?.collisionBitMask = bitMasks.walls
        
        paddle.physicsBody?.affectedByGravity = false
        paddle.physicsBody?.dynamic = true
        paddle.physicsBody?.allowsRotation = false
    }
    
    func getPaddle() -> SKSpriteNode {
        configurePaddle()
        return paddle
    }
    

}
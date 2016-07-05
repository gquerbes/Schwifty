//
//  Obstacle.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 7/5/16.
//  Copyright © 2016 Fourteen66. All rights reserved.
//

import SpriteKit


class Obstacle{
    
    let obstacle = SKSpriteNode (imageNamed: "object3")
    let bitMasks = PhysicsBitMasks()
    
    init(){
        //set obstacle
        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacle.size.width/2)
        obstacle.physicsBody?.affectedByGravity = true
        obstacle.physicsBody?.categoryBitMask = bitMasks.obstacle
        obstacle.physicsBody?.collisionBitMask = bitMasks.walls
    }
    
    
    func getObstacle() -> SKSpriteNode{
        return obstacle
    }
    
}
//
//  Paddle.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 7/4/16.
//  Copyright © 2016 Fourteen66. All rights reserved.
//

import Foundation
import SpriteKit

class Paddle : SKSpriteNode  {
    
    let sparkParticle : SKEmitterNode
    ///particle location
    let powerUpContactSparkPath = Bundle.main.pathForResource("PowerUpContactSpark", ofType: "sks")
    
    let bitMasks = PhysicsBitMasks()
    
    
    init(width: CGFloat, height: CGFloat){
        //declare texture for paddle
        let texture = SKTexture(imageNamed: "paddle_2_100x100")
        
        //particle instantiation
        sparkParticle = NSKeyedUnarchiver.unarchiveObject(withFile: powerUpContactSparkPath!) as! SKEmitterNode
        
       
        
        //set texture, color and size
        super.init(texture: texture, color: SKColor.clear(), size: CGSize(width: width, height: height))

        // 
//         self.addChild(sparkParticle)
        
        //set physics body of paddle
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
  
        //category for paddle
        physicsBody?.categoryBitMask = bitMasks.paddle
        //sprites that collisons will trigger event
        physicsBody?.contactTestBitMask =  bitMasks.powerUp | bitMasks.obstacle | bitMasks.bonus
        //sprites that will physically react to collision
        physicsBody?.collisionBitMask = bitMasks.walls
        
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        

        sparkParticle.isHidden = true
        self.addChild(sparkParticle)
      
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playSpark(){
        sparkParticle.isHidden = false
        sparkParticle.resetSimulation()
    }
    
}

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
    
    let powerUpContactSparkParticle : SKEmitterNode
    let obstacleContactLeftSparkParticle : SKEmitterNode
    let obstacleContactRightSparkParticle : SKEmitterNode
    
    
    let bitMasks = PhysicsBitMasks()
    
    
    init(width: CGFloat, height: CGFloat){
        //declare texture for paddle
        let texture = SKTexture(imageNamed: "paddle_2_100x100")
        
        ///particle location
        let powerUpContactSparkPath = Bundle.main.pathForResource("PowerUpContactSpark", ofType: "sks")
        let obstacleContactSparkPath = Bundle.main.pathForResource("ObstacleContactSpark", ofType: "sks")

        
        //particle instantiation
        powerUpContactSparkParticle = NSKeyedUnarchiver.unarchiveObject(withFile: powerUpContactSparkPath!) as! SKEmitterNode
        
        obstacleContactLeftSparkParticle = NSKeyedUnarchiver.unarchiveObject(withFile: obstacleContactSparkPath!) as! SKEmitterNode
        
        obstacleContactRightSparkParticle = NSKeyedUnarchiver.unarchiveObject(withFile: obstacleContactSparkPath!) as! SKEmitterNode
       
        
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
        

        powerUpContactSparkParticle.isHidden = true
        self.addChild(powerUpContactSparkParticle)
      
        obstacleContactLeftSparkParticle.isHidden = true
        self.addChild(obstacleContactLeftSparkParticle)
        
        obstacleContactRightSparkParticle.isHidden = true
        self.addChild(obstacleContactRightSparkParticle)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func playSpark(type: String, position1: CGPoint, position2: CGPoint?){
        var particles = [SKEmitterNode]()
        
        switch type{
        case "PowerUp" :
            particles.append(powerUpContactSparkParticle)
            particles[0].position = position1
        case "Obstacle" :
            particles.append(obstacleContactLeftSparkParticle)
            particles.append(obstacleContactRightSparkParticle)
            particles[0].position = position1
            particles[1].position = position2!
        default:
            fatalError("invalid particle type")
        }
        
        for particle in particles {
            if particle.isHidden {
                particle.isHidden = false
            }
            particle.resetSimulation()
        }
    }
    
}

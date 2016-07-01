//
//  GameScene.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 6/28/16.
//  Copyright (c) 2016 Fourteen66. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    //ball
    var ball:SKSpriteNode!
    var ballWidth:CGFloat = 100.0
    
    
    //location of touch 
    var touchLocation: CGPoint = CGPoint(x: 768, y: 0)
    
    // labels
    var currentScoreLabel: SKLabelNode!
    
    //score
    var currentScore = 0
    
    //physics variable
    struct PhysicsCategory {
        static let none : UInt32 = 0
        static let all : UInt32 = UInt32.max
        static let ball : UInt32 = 0x1       // 1
        static let obstacle : UInt32 = 0x1 << 1      // 2
    }
    
    
    /**
     Configure view
    */
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //physics
        physicsWorld.gravity = CGVectorMake(0, -10)
        physicsWorld.contactDelegate = self
    
        
        //set ball in code
        ball = self.childNodeWithName("ball") as! SKSpriteNode
        setBallProperties()
        
        
        
        //score label
        currentScoreLabel = SKLabelNode(fontNamed: "Ariel")
        //center location of screen
        currentScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        currentScoreLabel.fontSize = 65
        self.addChild(currentScoreLabel)
        
        
        // call and repeat action of presenting obstacles
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addObstacles),
                SKAction.waitForDuration(0.3 )
                ])
            ))
        
    }
    
    
    func setBallProperties(){
        
//        ball.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: ballWidth, height: 100))
        
        ball.size.width = ballWidth
        //category for obstacle
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        //sprites that collisons will trigger event
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle
        //sprites that will physically react to collison
        ball.physicsBody?.collisionBitMask = PhysicsCategory.obstacle
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.dynamic = false
        
        print(ball.size.width)
    }
    /**
     Add obstacles to screen
    */
    func addObstacles(){
        // obstacle
        let obstacle = SKSpriteNode (imageNamed: "object3")
    
        
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        obstacle.position = randomXInView()
        
        //set obstacle
        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacle.size.width)
        obstacle.physicsBody?.affectedByGravity = true
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        self.addChild(obstacle)
        
        
        //update score
        currentScore += 1
        currentScoreLabel.text = String(currentScore)
    }
    
    /**
     - Returns:randomized X coordinate within frame
    */
    func randomXInView() -> CGPoint{
        let sizeX = Int(CGRectGetMaxX(self.frame) + 15)
        let randomX = CGFloat(Int(arc4random()) % sizeX)
        return CGPointMake(randomX, 2000)
        
    }
    /**
     converts CG point to make game work across all screen dimensions
    */
    func convert(point: CGPoint)->CGPoint {
        return self.view!.convertPoint(CGPoint(x: point.x, y:self.view!.frame.height-point.y), toScene:self)
    }
    
    /**
     Called when a contact is made
    */
    func didBeginContact(contact: SKPhysicsContact) {
        
        let ball = (contact.bodyA.categoryBitMask == PhysicsCategory.ball) ? contact.bodyA : contact.bodyB
        
        let other = (ball == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        //handle obstacle hitting ball
        if other.categoryBitMask == PhysicsCategory.obstacle{
            other.node?.removeFromParent()
            increaseBallSize()
            print()
        }
    }
    
    func increaseBallSize(){
        ballWidth+=20
        setBallProperties()
        
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        touchLocation = touches.first!.locationInNode(self)
    }
   
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchLocation = touches.first!.locationInNode(self)
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //location of touch
        let location = touchLocation.x
        
        //move ball to location of touch
        let move = SKAction.moveToX(location, duration: 0.1)//adjust tracking speed
        ball.runAction(move)
        
    
    }
}

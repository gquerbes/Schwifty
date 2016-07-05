//
//  GameScene.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 6/28/16.
//  Copyright (c) 2016 Fourteen66. All rights reserved.
//
/* MARK: TODO
    1. Add variable speed with stages
    2. Add new powerUp to return to original size?
    3. Moving wallpaper
    4. Track high score
    5. Start Screen
    6. End of game logic
    7. Improved scoring system
    8. Place objects into seperate files
 */

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    //declare paddle
    var paddle:SKSpriteNode!
    //paddle class
    let paddleObj = Paddle()

    
    //walls
    var leftWall: SKSpriteNode!
    var rightWall: SKSpriteNode!
    
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
        static let paddle : UInt32 = 0x1     // 1
        static let obstacle : UInt32 = 0x1 << 1      // 2
        static let powerUp : UInt32 = 0x1 << 2    // 4
        static let walls : UInt32 = 0x1 << 3
    }
    
    
    /**
     Configure view
    */
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //physics
        physicsWorld.gravity = CGVectorMake(0, -20)
        physicsWorld.contactDelegate = self
        
        
        //set paddle
        paddle = paddleObj.getPaddle()
        paddle.position = (CGPointMake(CGRectGetMidX(self.frame), 600.0))
        self.addChild(paddle)
        
    
        
        
        //set Walls
        leftWall = self.childNodeWithName("leftWall") as! SKSpriteNode
        rightWall = self.childNodeWithName("rightWall") as! SKSpriteNode
        
        setWallProperties()
        
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
                SKAction.waitForDuration(0.4 )
                ])
            ))
        
        // call and repeat action of presenting powerUps
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addPowerUp),
                SKAction.waitForDuration(6.0 )
                ])
            ))

    }
    


    
    func setWallProperties(){
        //wall physics body
        leftWall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 100, height: 2048))
        rightWall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 100, height: 2048))
        
        //category bit masks
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.walls
        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.walls
        
        //collision bit masks
        leftWall.physicsBody?.collisionBitMask = PhysicsCategory.paddle
        rightWall.physicsBody?.collisionBitMask = PhysicsCategory.paddle
        
        //gravity properties
        leftWall.physicsBody?.affectedByGravity = false
        rightWall.physicsBody?.affectedByGravity = false
        
        //affected by physics
        leftWall.physicsBody?.dynamic = false
        rightWall.physicsBody?.dynamic = false
        
        
        
    }
    /**
      adds powerUp object to scene
    */
    func addPowerUp(){
        let powerUp = SKSpriteNode(imageNamed: "object1")
        powerUp.position = randomXInView()
        powerUp.physicsBody = SKPhysicsBody(circleOfRadius: powerUp.size.width/2)
        powerUp.physicsBody?.affectedByGravity = true
        powerUp.physicsBody?.categoryBitMask = PhysicsCategory.powerUp
        
        self.addChild(powerUp)
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
        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacle.size.width/2)
        obstacle.physicsBody?.affectedByGravity = true
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        obstacle.physicsBody?.collisionBitMask = PhysicsCategory.walls
        self.addChild(obstacle)
        
        
        //update score
        currentScore += 1
        currentScoreLabel.text = String(currentScore)
    }
    
    /**
     - Returns:randomized X coordinate within frame at Y position 2000
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
        
        let aPaddle = (contact.bodyA.categoryBitMask == PhysicsCategory.paddle) ? contact.bodyA : contact.bodyB
        
        let other = (aPaddle == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        //handle obstacle hitting paddle
        if other.categoryBitMask == PhysicsCategory.obstacle{
            other.node?.removeFromParent()
            paddleObj.increasePaddleSize()
    
        }
        else if other.categoryBitMask == PhysicsCategory.powerUp{
            other.node?.removeFromParent()
            paddleObj.decreasePaddleSize()
        }
        
        //replace paddle with resized version
        let paddlePosition = paddle.position
        paddle.removeFromParent()
        paddle = paddleObj.getPaddle()
        paddle.position = paddlePosition
        self.addChild(paddle)
    
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
        
        //move paddle to location of touch
        let move = SKAction.moveToX(location, duration: 0.1)//adjust tracking speed
        paddle.runAction(move)
       
        
    
    }
}

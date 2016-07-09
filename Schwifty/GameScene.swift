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
X    5. Start Screen 
X    6. End of game logic
    7. Improved scoring system
X    8. Place objects into seperate files
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
    var touchLocation: CGPoint = CGPoint(x: 540, y: 0)
    
    // labels
    var currentScoreLabel: SKLabelNode!
    
    //score
    var currentScore = 0
    
    //physics variable
    let bitMasks = PhysicsBitMasks()

    
    
    /**
     Configure view
    */
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        //physics
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        physicsWorld.contactDelegate = self
        
        
        //set paddle
        paddle = paddleObj.getPaddle()
        paddle.position = (CGPoint(x: self.frame.midX, y: 600.0))
        self.addChild(paddle)
        
    
        
        
        //set Walls
        leftWall = self.childNode(withName: "leftWall") as! SKSpriteNode
        rightWall = self.childNode(withName: "rightWall") as! SKSpriteNode
        
        setWallProperties()
        
        //score label
        currentScoreLabel = SKLabelNode(fontNamed: "Ariel")
        //center location of screen
        currentScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        currentScoreLabel.fontSize = 65
        self.addChild(currentScoreLabel)
        
        
        // call and repeat action of presenting obstacles
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addObstacles),
                SKAction.wait(forDuration: 0.4 )
                ])
            ))
        
        // call and repeat action of presenting powerUps
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addPowerUp),
                SKAction.wait(forDuration: 6.0 )
                ])
            ))

    }
    


    

    /**
      adds powerUp object to scene
    */
    func addPowerUp(){
        //create powerUp from class
        let powerUpObject = PowerUp()
        let powerUp = powerUpObject.getPowerUp()
        //set power up to random location
        powerUp.position = randomXInView()
        self.addChild(powerUp)
    }
    
    /**
     Add obstacles to screen
    */
    func addObstacles(){
        
        //obstacle class
        let obstacleObject = Obstacle()
        //create obstacle
        let obstacle = obstacleObject.getObstacle()
        obstacle.position = randomXInView()
        self.addChild(obstacle)
        
        
        //update score
        currentScore += 1
        currentScoreLabel.text = String(currentScore)
    }
    
    /**
     - Returns:randomized X coordinate within frame at Y position 2000
    */
    func randomXInView() -> CGPoint{
        let sizeX = Int(self.frame.maxX + 15)
        let randomX = CGFloat(Int(arc4random()) % sizeX)
        return CGPoint(x: randomX, y: 2000)
        
    }
    /**
     converts CG point to make game work across all screen dimensions
    */
    func convert(_ point: CGPoint)->CGPoint {
        return self.view!.convert(CGPoint(x: point.x, y:self.view!.frame.height-point.y), to:self)
    }
    
    /**
     Called when a contact is made
    */
    func didBegin(_ contact: SKPhysicsContact) {
        
        let aPaddle = (contact.bodyA.categoryBitMask == bitMasks.paddle) ? contact.bodyA : contact.bodyB
        
        let other = (aPaddle == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        //handle obstacle hitting paddle
        if other.categoryBitMask == bitMasks.obstacle{
            other.node?.removeFromParent()
            //end game if paddle passes certain width
            if paddleObj.paddleWidth >= 380 {
                //present main menu
                let menu:GameScene = GameScene(fileNamed: "MainMenu")!
                menu.scaleMode = .aspectFill
                let transition = SKTransition.flipHorizontal(withDuration: 1)
                self.view?.presentScene(menu,transition: transition)
            }
            else{
                paddleObj.increasePaddleSize()
                replacePaddle()
            }
        }
        else if other.categoryBitMask == bitMasks.powerUp{
            other.node?.removeFromParent()
            paddleObj.decreasePaddleSize()
            replacePaddle()
        }
    }
    
    
    //replace paddle with resized version
    func replacePaddle(){
        //copy current position of paddle
        let paddlePosition = paddle.position
        //remove paddle and add resized paddle to same position
        paddle.removeFromParent()
        paddle = paddleObj.getPaddle()
        paddle.position = paddlePosition
        self.addChild(paddle)
    }
    
    func setWallProperties(){
        //wall physics body
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 2048))
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 2048))
        
        //category bit masks
        leftWall.physicsBody?.categoryBitMask = bitMasks.walls
        rightWall.physicsBody?.categoryBitMask = bitMasks.walls
        
        //collision bit masks
        leftWall.physicsBody?.collisionBitMask = bitMasks.paddle
        rightWall.physicsBody?.collisionBitMask = bitMasks.paddle
        
        //gravity properties
        leftWall.physicsBody?.affectedByGravity = false
        rightWall.physicsBody?.affectedByGravity = false
        
        //affected by physics
        leftWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.isDynamic = false
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        touchLocation = touches.first!.location(in: self)
    }
   
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchLocation = touches.first!.location(in: self)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        //location of touch
        let location = touchLocation.x
        
        //move paddle to location of touch
        let move = SKAction.moveTo(x: location, duration: 0.05)//adjust tracking speed
        paddle.run(move)
       
        
    
    }
}

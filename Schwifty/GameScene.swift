//
//  GameScene.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 6/28/16.
//  Copyright (c) 2016 Fourteen66. All rights reserved.
//
/* MARK: TODO
    * Add variable speed with stages
    * Add new powerUp to return to original size?
X    * Track high score
X    * Start Screen
X    * End of game logic
    * Improved scoring system
X    * Place objects into seperate files
    * Create particle affects for each object type
 
 */

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    //paddle class
    var paddleWidth:CGFloat = 100
    var paddleHeight: CGFloat = 40
    var paddle = Paddle(width: 100, height: 40)

    
    
    //walls
    var leftWall: SKSpriteNode!
    var rightWall: SKSpriteNode!
    var floor : SKSpriteNode!
    
    //location of touch 
    var touchLocation: CGPoint = CGPoint(x: 540, y: 0)
    
    // labels
    var currentScoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    
    //score
    var currentScore = 0
    var highScore = 0
 
    //user defaults
    let userDefaults = UserDefaults.standard
    
    
    //physics variable
    let bitMasks = PhysicsBitMasks()

    //game variables
    var downwardForce : Int = -400
    var powerUpCounter : Int = 0
    
    //dropped items
    var obstacle = Obstacle()
    var powerUps = [PowerUp]()
    
    
    
    /**
     Configure view
    */
    override func didMove(to view: SKView) {
        
        //load powerUps
        loadPowerUps()
        
        //clear high score
//        userDefaults.setValue(0, forKey: "highScore")
//        userDefaults.synchronize()

        
        ///Check if high score is on local storage and set it on game
        if let highScoreOnFile = userDefaults.value(forKey: "highScore") {
            /// do something here when a high score exists
            highScore = highScoreOnFile as! Int
            print("highScore on file is: \(highScore)")
        }
        
        //wallpaper
        let background = SKSpriteNode(imageNamed: "Schwifty_Wallpaper.png")
        background.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        //physics
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        
        //set paddle
        paddle.position = (CGPoint(x: self.frame.midX, y: 600.0))
        paddle.zPosition = 1
        self.addChild(paddle)
    
        
    
        
        
        //set Walls
        leftWall = self.childNode(withName: "leftWall") as! SKSpriteNode
        rightWall = self.childNode(withName: "rightWall") as! SKSpriteNode
        floor = self.childNode(withName: "floor") as! SKSpriteNode
        
        setWallProperties()
        
        //score label
        currentScoreLabel = SKLabelNode(fontNamed: "Ariel")
        //center location of screen
        currentScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        currentScoreLabel.fontSize = 65
        currentScoreLabel.fontColor = SKColor.black()
        currentScoreLabel.zPosition = 1
        self.addChild(currentScoreLabel)
        

        
        // call and repeat action of presenting obstacles
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(dropObstacle),
                SKAction.wait(forDuration: 2.5 )
                ])
            ))
        
        // call and repeat action of presenting powerUps
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(dropPowerUp),
                SKAction.wait(forDuration: 0.4 )
                ])
            ))

        // call and repeat action of increasing the downward force
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(increaseDownwardForce),
                SKAction.wait(forDuration: 9.0 )
                ])
            ))
        
        // call and repeat action of increasing the downward force
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addBonus),
                SKAction.wait(forDuration: 6.1 )
                ])
            ))
    }
    

    func loadPowerUps(){
        for _ in 0..<10{
            let powerUp = PowerUp()
            powerUp.zPosition = 1
            powerUp.name = "powerUp"
            powerUps.append(powerUp)
        }
    }

    
    func dropPowerUp(){
        incrementPowerUpCounter()
        let powerUp = powerUps[powerUpCounter]
        powerUp.position = randomXInView()
        if powerUp.parent != nil {
            powerUp.removeFromParent()
        }
            self.addChild(powerUp)
    }

    func incrementPowerUpCounter(){
        //print("powerUpCount \(powerUps.count)")
        if powerUpCounter < powerUps.count - 1 {
            powerUpCounter += 1
        }
        else{
            powerUpCounter = 0
        }
    }
    
    func dropObstacle(){
        obstacle.position = randomXInView()
        obstacle.zPosition = 1
        self.addChild(obstacle)
        obstacle.name = "obstacle"
    }

    

    /**
      adds powerUp object to scene
    */
//    func addPowerUp(){
//        //create powerUp from class
//        let powerUp = PowerUp()
//        //set power up to random location
//        powerUp.position = randomXInView()
//        powerUp.zPosition = 1
//        self.addChild(powerUp)
//        powerUp.name = "powerUp"
//        
//        updateScore()
//    }
    
    /**
     adds bonus object to scene
     */
    func addBonus(){
        //create powerUp from class
        let bonus = Bonus()
        //set power up to random location
        bonus.position = randomXInView()
        bonus.zPosition = 1
        self.addChild(bonus)
        bonus.name = "bonus"
    }
    

    
    func updateScore(increment: Int){
        currentScore += increment
        currentScoreLabel.text = String(currentScore)
    }
    /**
     - Returns:randomized X coordinate within frame at Y position 2000
    */
//    func randomXInView() -> CGPoint{
//        let sizeX = Int(self.frame.maxX + 15)
//        let randomX = CGFloat(Int(arc4random()) % sizeX)
//        return CGPoint(x: randomX, y: 2000)
//        
//    }
    
    /**
     - Returns:randomized X coordinate within frame at Y position 2000
     */
    func randomXInView() -> CGPoint{
        let randomXPosition = GKShuffledDistribution(lowestValue: Int(self.frame.minX), highestValue: Int(self.frame.maxX))
        return CGPoint(x:randomXPosition.nextInt(), y: 2000)
    
    }
  
    
    /**
     Called when a contact is made
    */
    func didBegin(_ contact: SKPhysicsContact) {
        //get contact mask of 2 colliding bodies
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        //paddle edges
        
        
        switch contactMask{
        case PhysicsBitMasks().powerUp | PhysicsBitMasks().paddle:
            let powerUp = (contact.bodyA.categoryBitMask == bitMasks.powerUp) ? contact.bodyA : contact.bodyB
            updateScore(increment: 1)
//            updatePaddleSize(amount: 2)
            powerUp.node?.removeFromParent()
            
            //position the sparkParticle at location of collision relative to paddle
            let contactPosition = convert(contact.contactPoint, to: paddle)
            //play spark particle
            self.paddle.playSpark(type: "PowerUp", position1: contactPosition, position2: nil)
            
            
        case PhysicsBitMasks().powerUp | PhysicsBitMasks().floor:
            let powerUp = (contact.bodyA.categoryBitMask == bitMasks.powerUp) ? contact.bodyA : contact.bodyB
            powerUp.node?.removeFromParent()
            updatePaddleSize(amount: -20)
            
            let rightEdge = self.paddle.size.width/2
            let leftEdge = rightEdge - self.paddle.size.width
            //play spark particle
            self.paddle.playSpark(type: "Obstacle", position1: CGPoint(x: leftEdge, y: 0.0),position2:  CGPoint(x: rightEdge, y: 0.0))
            
        
        case PhysicsBitMasks().bonus | PhysicsBitMasks().paddle:
            let bonus = (contact.bodyA.categoryBitMask == bitMasks.bonus) ? contact.bodyA : contact.bodyB
            updateScore(increment: 5)
            updatePaddleSize(amount: 100)
            bonus.node?.removeFromParent()
            
            
        case PhysicsBitMasks().bonus | PhysicsBitMasks().floor:
            let bonus = (contact.bodyA.categoryBitMask == bitMasks.bonus) ? contact.bodyA : contact.bodyB
            bonus.node?.removeFromParent()
            
            
        case PhysicsBitMasks().obstacle | PhysicsBitMasks().paddle:
            let obstacle = (contact.bodyA.categoryBitMask == bitMasks.obstacle) ? contact.bodyA : contact.bodyB
            obstacle.node?.removeFromParent()
//            updateScore(increment: -10)
            updatePaddleSize(amount: -80)
           
            let rightEdge = self.paddle.size.width/2
            let leftEdge = rightEdge - self.paddle.size.width
            
            //play spark particle
            self.paddle.playSpark(type: "Obstacle", position1: CGPoint(x: leftEdge, y: 0.0),position2:  CGPoint(x: rightEdge, y: 0.0))
            

            
            
        case PhysicsBitMasks().obstacle | PhysicsBitMasks().floor:
            let obstacle = (contact.bodyA.categoryBitMask == bitMasks.obstacle) ? contact.bodyA : contact.bodyB
            obstacle.node?.removeFromParent()
            
            
        default: fatalError("unrecognized collision")
        }
    }
    
    func updatePaddleSize(amount: Int){
        paddleWidth += CGFloat(amount)
        if paddleWidth <= 0{
            endGame()
        }
        else if paddleWidth >= 400{
            
        }
            
        else{
            //copy current position of paddle
            let paddlePosition = paddle.position
            //remove paddle and add resized paddle to same position
            paddle.removeFromParent()
            paddle = Paddle(width: paddleWidth, height: paddleHeight)
            paddle.position = paddlePosition
            paddle.zPosition = 1
            self.addChild(paddle)
        }
        
    }
 
    func endGame(){
        //main menu
        let menu = MainMenu(fileNamed: "MainMenu")!
        menu.scaleMode = .aspectFill
        let transition = SKTransition.flipHorizontal(withDuration: 1)
        
        if currentScore > highScore{
            menu.isNewHighScore = true
            highScore = currentScore
            //write high score to local storage
            userDefaults.setValue(highScore, forKey: "highScore")
            userDefaults.synchronize()
        }
        //present main menu
        self.view?.presentScene(menu,transition: transition)
    }
    
    
    func increaseDownwardForce(){
        downwardForce -= 500
    }

    
    
 
    
    func setWallProperties(){
        //floor physics
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1080, height: 100))
        floor.physicsBody?.categoryBitMask = bitMasks.floor
        floor.physicsBody?.contactTestBitMask = bitMasks.powerUp | bitMasks.obstacle | bitMasks.bonus
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.isDynamic = false
        
        //left wall physics
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 2048))
        leftWall.physicsBody?.categoryBitMask = bitMasks.walls
        leftWall.physicsBody?.collisionBitMask = bitMasks.paddle
        leftWall.physicsBody?.affectedByGravity = false
        leftWall.physicsBody?.isDynamic = false

        //right wall physics
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 2048))
        rightWall.physicsBody?.categoryBitMask = bitMasks.walls
        rightWall.physicsBody?.collisionBitMask = bitMasks.paddle
        rightWall.physicsBody?.affectedByGravity = false
        rightWall.physicsBody?.isDynamic = false
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
       
        self.enumerateChildNodes(withName: "powerUp", using: {
            
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            // do something with node or stop
            node.physicsBody?.applyForce((CGVector(dx: -300, dy:self.downwardForce))
            )
            return
        })
    
        self.enumerateChildNodes(withName: "bonus", using: {
            
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            // do something with node or stop
            node.physicsBody?.applyForce((CGVector(dx: -600, dy:self.downwardForce))
            )
            return
        })
        
        self.enumerateChildNodes(withName: "obstacle", using: {
            
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            // do something with node or stop
            node.physicsBody?.applyForce((CGVector(dx: 0, dy:self.downwardForce))
            )
            return
        })
    }
}



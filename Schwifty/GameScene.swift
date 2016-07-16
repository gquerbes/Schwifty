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
    //paddle class
    var paddleWidth:CGFloat = 380
    var paddleHeight: CGFloat = 40
    var paddle = SKSpriteNode()
    
    
    //walls
    var leftWall: SKSpriteNode!
    var rightWall: SKSpriteNode!
    var floor : SKSpriteNode!
    
    //location of touch 
    var touchLocation: CGPoint = CGPoint(x: 540, y: 0)
    
    // labels
    var currentScoreLabel: SKLabelNode!
    
    //score
    var currentScore = 0
    
    //physics variable
    let bitMasks = PhysicsBitMasks()

    //game variables
    var downwardForce : Int = -1000
    var powerUpCounter : Int = 0
    
    //dropped items
    var obstacle = Obstacle()
    var powerUps = [PowerUp]()
    
    
    
    /**
     Configure view
    */
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        //load powerUps
        loadPowerUps()
        
        //wallpaper
        let background = SKSpriteNode(imageNamed: "Schwifty_Wallpaper.png")
        background.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        //physics
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        
        //set paddle
        paddle = Paddle(width: paddleWidth, height: paddleHeight)
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
                SKAction.wait(forDuration: 5.0 )
                ])
            ))
        
        // call and repeat action of presenting powerUps
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(dropPowerUp),
                SKAction.wait(forDuration: 0.2 )
                ])
            ))

        // call and repeat action of increasing the downward force
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(increaseDownwardForce),
                SKAction.wait(forDuration: 10.0 )
                ])
            ))
        
        // call and repeat action of increasing the downward force
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addBonus),
                SKAction.wait(forDuration: 10.0 )
                ])
            ))
    }
    

    func loadPowerUps(){
        for _ in 0...30{
            let powerUp = PowerUp()
            powerUp.zPosition = 1
            powerUp.name = "powerUp"
            powerUps.append(powerUp)
        }
    }
//
    func dropPowerUp(){
        let powerUp = powerUps[powerUpCounter]
        incrementPowerUpCounter()
        powerUp.position = randomXInView()
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
    
    /**
     Add obstacles to screen
     REPLACED BY dropObstacle
    */
//    func addObstacles(){
//        //create obstacle
//        let obstacle = Obstacle()
//        obstacle.position = randomXInView()
//        obstacle.zPosition = 1
//        obstacle.name = "obstacle"
//        self.addChild(obstacle)
//        
//    }
    
    func updateScore(){
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
        
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask{
        case PhysicsBitMasks().paddle | PhysicsBitMasks().powerUp:
            let powerUp = (contact.bodyA.categoryBitMask == bitMasks.powerUp) ? contact.bodyA : contact.bodyB
            //let paddle = (powerUp == contact.bodyA) ? contact.bodyB : contact.bodyA
            print("paddle")
            powerUp.node?.removeFromParent()
            
        case PhysicsBitMasks().powerUp | PhysicsBitMasks().floor:
            let powerUp = (contact.bodyA.categoryBitMask == bitMasks.powerUp) ? contact.bodyA : contact.bodyB
            //let paddle = (powerUp == contact.bodyA) ? contact.bodyB : contact.bodyA
            print("floor")
            powerUp.node?.removeFromParent()
            decreasePaddleSize()
            
            if self.paddle.size.width <= 0.0 {
                //present main menu
                let menu:GameScene = GameScene(fileNamed: "MainMenu")!
                menu.scaleMode = .aspectFill
                let transition = SKTransition.flipHorizontal(withDuration: 1)
                self.view?.presentScene(menu,transition: transition)
            }
        
        case PhysicsBitMasks().paddle | PhysicsBitMasks().bonus:
            let bonus = (contact.bodyA.categoryBitMask == bitMasks.bonus) ? contact.bodyA : contact.bodyB
            print("got a bonus")
            bonus.node?.removeFromParent()
            increasePaddleSize()//clean this up dude
            increasePaddleSize()
            increasePaddleSize()
            increasePaddleSize()
            
            
        case PhysicsBitMasks().floor | PhysicsBitMasks().bonus:
            let bonus = (contact.bodyA.categoryBitMask == bitMasks.bonus) ? contact.bodyA : contact.bodyB
            print("missed a bonus")
            bonus.node?.removeFromParent()
            
        case PhysicsBitMasks().obstacle | PhysicsBitMasks().paddle:
            let obstacle = (contact.bodyA.categoryBitMask == bitMasks.obstacle) ? contact.bodyA : contact.bodyB
            print("caught an obstacle")
            obstacle.node?.removeFromParent()
            decreasePaddleSize()
            decreasePaddleSize()
            decreasePaddleSize()
            decreasePaddleSize()
            
        case PhysicsBitMasks().obstacle | PhysicsBitMasks().floor:
            let obstacle = (contact.bodyA.categoryBitMask == bitMasks.obstacle) ? contact.bodyA : contact.bodyB
            print("Missed an obstacle")
            obstacle.node?.removeFromParent()
            
            
        default: fatalError("unrecognized collision")
        }
    }
    
    func increasePaddleSize(){
        paddleWidth+=20
        replacePaddle()
    }
    
    func decreasePaddleSize(){
        paddleWidth-=20
        replacePaddle()
    }
    
    func increaseDownwardForce(){
        downwardForce -= 500
    }
    /**
     Reset paddle to starting size
    */
    func resetPaddle(){
//        paddleObj.paddleWidth(
    }
    
    
    //replace paddle with resized version
    func replacePaddle(){
        //copy current position of paddle
        let paddlePosition = paddle.position
        //remove paddle and add resized paddle to same position
        paddle.removeFromParent()
        paddle = Paddle(width: paddleWidth, height: paddleHeight)
        paddle.position = paddlePosition
        paddle.zPosition = 1
        self.addChild(paddle)
    }
    
    func setWallProperties(){
        //floor physics
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1080, height: 100))
        floor.physicsBody?.categoryBitMask = bitMasks.floor
        floor.physicsBody?.contactTestBitMask = bitMasks.powerUp | bitMasks.obstacle | bitMasks.bonus
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.isDynamic = false
        
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
       
        self.enumerateChildNodes(withName: "powerUp", using: {
            
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            // do something with node or stop
            node.physicsBody?.applyForce((CGVector(dx: 0, dy:self.downwardForce))
            )
            return
        })
    
        self.enumerateChildNodes(withName: "bonus", using: {
            
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            // do something with node or stop
            node.physicsBody?.applyForce((CGVector(dx: 0, dy:self.downwardForce))
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


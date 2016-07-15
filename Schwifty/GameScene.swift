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
//    var paddle:SKSpriteNode!
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
    
    /**
     Configure view
    */
    override func didMove(to view: SKView) {
        /* Setup your scene here */
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
//        run(SKAction.repeatForever(
//            SKAction.sequence([
//                SKAction.run(addObstacles),
//                SKAction.wait(forDuration: 0.8 )
//                ])
//            ))
        
        // call and repeat action of presenting powerUps
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addPowerUp),
                SKAction.wait(forDuration: 0.3 )
                ])
            ))

        // call and repeat action of increasing the downward force
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(increaseDownwardForce),
                SKAction.wait(forDuration: 10.0 )
                ])
            ))

    }
    


    

    /**
      adds powerUp object to scene
    */
    func addPowerUp(){
        //create powerUp from class
        let powerUp = PowerUp()
        //set power up to random location
        powerUp.position = randomXInView()
        powerUp.zPosition = 1
        self.addChild(powerUp)
        powerUp.name = "powerUp"
        
        updateScore()
    }
    
    /**
     Add obstacles to screen
    */
    func addObstacles(){
        
        //create obstacle
        let obstacle = Obstacle()
        obstacle.position = randomXInView()
        obstacle.zPosition = 1
        self.addChild(obstacle)
        
        
    }
    
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
        
        //what i need to do
        //http://stackoverflow.com/questions/26702944/swift-spritekit-multiple-collision-detection
        
        
        let powerUp = (contact.bodyA.categoryBitMask == bitMasks.powerUp) ? contact.bodyA : contact.bodyB
        
        let other = (powerUp == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        //perform action if paddle hits powerUp
        if other.categoryBitMask == bitMasks.paddle{
            print("paddle")
            powerUp.node?.removeFromParent()
        }
            //perform action if paddle misses powerUp
        else if other.categoryBitMask == bitMasks.floor{
            print("floor")
            powerUp.node?.removeFromParent()
            decreasePaddleSize()
            replacePaddle()
            if paddle.size.width <= 0.0 {
                    //present main menu
                let menu:GameScene = GameScene(fileNamed: "MainMenu")!
                menu.scaleMode = .aspectFill
                let transition = SKTransition.flipHorizontal(withDuration: 1)
                self.view?.presentScene(menu,transition: transition)
            }
        }
    }
    
    func increasePaddleSize(){
        paddleWidth+=20
    }
    
    func decreasePaddleSize(){
        paddleWidth-=20
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
        floor.physicsBody?.collisionBitMask = bitMasks.powerUp | bitMasks.obstacle
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
    
    }
}


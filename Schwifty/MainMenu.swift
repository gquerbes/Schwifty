//
//  MainMenu.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 7/5/16.
//  Copyright © 2016 Fourteen66. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    //user Defaults
    let userDefaults = UserDefaults.standard
    var isNewHighScore = false

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let game:GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .aspectFill
        let transition:SKTransition = SKTransition.crossFade(withDuration: 1.0)
        self.view?.presentScene(game, transition: transition)
    }
    
    override func didMove(to view: SKView) {
        //configure wallpaper
        let background = SKSpriteNode(imageNamed: "Schwifty_HomeScreen.png")
        background.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        //show high score
        if let highScore = userDefaults.value(forKey: "highScore"){

            let highScoreLabel = SKLabelNode(text: "High Score: \(highScore) ")
            highScoreLabel.fontSize = 50
            highScoreLabel.fontColor = SKColor.darkGray()
            highScoreLabel.fontName = "Trebuchet MS Bold"
            highScoreLabel.zPosition = 1
            highScoreLabel.position = CGPoint(x:self.size.width/2, y:self.size.height/1.25)
            self.addChild(highScoreLabel)

            if isNewHighScore{
                let newHighScoreLabel = SKLabelNode(text: "NEW HIGH SCORE!")
                newHighScoreLabel.fontSize = 70
                newHighScoreLabel.fontColor = SKColor.blue()
                newHighScoreLabel.fontName = "Trebuchet MS Bold"
                newHighScoreLabel.zPosition = 1
                newHighScoreLabel.position = CGPoint(x:self.size.width/2, y:self.size.height/1.35)
                self.addChild(newHighScoreLabel)
                
                //particle
                let powerUpContactSparkPath = Bundle.main.pathForResource("PowerUpContactSpark", ofType: "sks")
                let powerUpContactSparkParticle = NSKeyedUnarchiver.unarchiveObject(withFile: powerUpContactSparkPath!) as! SKEmitterNode
                powerUpContactSparkParticle.position = newHighScoreLabel.position
                powerUpContactSparkParticle.zPosition = 1
                self.addChild(powerUpContactSparkParticle)
            }
            
        }
    }
}

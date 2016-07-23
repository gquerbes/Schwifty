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
            let highScoreLabel = SKLabelNode(text: "High Score: \(highScore)")
            highScoreLabel.zPosition = 1
            highScoreLabel.fontSize = 50
            highScoreLabel.fontColor = SKColor.darkGray()
            highScoreLabel.fontName = "Trebuchet MS Bold"
            highScoreLabel.position = CGPoint(x:self.size.width/2, y:self.size.height/1.25)
            self.addChild(highScoreLabel)
        }
    }
}

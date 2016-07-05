//
//  MainMenu.swift
//  Schwifty
//
//  Created by Gabriel Querbes on 7/5/16.
//  Copyright © 2016 Fourteen66. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let game:GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .AspectFill
        let transition:SKTransition = SKTransition.crossFadeWithDuration(1.0)
        self.view?.presentScene(game, transition: transition)
    }
}

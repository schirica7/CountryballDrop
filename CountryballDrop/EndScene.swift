//
//  EndScene.swift
//  CountryballDrop
//
//  Created by Sneezy on 4/12/23.
//

import UIKit
import SpriteKit

class EndScene: SKScene {

    var win = false
    var gameOver = SKSpriteNode()
    var playAgain = SKLabelNode()

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        populateScene(win: win)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
//            if !win {
            if nodes(at: location).contains(playAgain) {
                let scene = SKScene(fileNamed: "GameScene")! as! GameScene
                
                //scene.tim
                let transition = SKTransition.crossFade(withDuration: 1)
                self.view?.presentScene(scene, transition: transition)
                return
            }
//                }
//            } else {
//                if nodes(at: location).contains(playAgain) {
//                    //TODO: Do something
//                }
//            }
            
            /*for ball in balls {
             }
             }*/
        }
    }
    
    func populateScene(win: Bool) {
        if !win {
            gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
            addChild(gameOver)

        } else {
            let win = SKLabelNode(text: "You win!")
            win.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
            addChild(win)
            
        }
        
        playAgain = SKLabelNode(text: "Play Again?")
        playAgain.position = CGPoint(x: self.size.width/2, y: self.size.height*0.4)
        playAgain.fontSize = 60
        playAgain.fontName = "American Typewriter"
        addChild(playAgain)
    }
}

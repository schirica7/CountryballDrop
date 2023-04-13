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
    var playAgain = SKSpriteNode()

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        populateScene(win: win)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if !win {
                if nodes(at: location).contains(gameOver) {
                    let scene = SKScene(fileNamed: "GameScene")! as! GameScene
                    let transition = SKTransition.crossFade(withDuration: 1)
                    self.view?.presentScene(scene, transition: transition)
                    return
                }
            } else {
                if nodes(at: location).contains(playAgain) {
                    //TODO: Do something
                }
            }
            
            /*for ball in balls {
             }
             }*/
        }
    }
    
    func populateScene(win: Bool) {
        if !win {
            gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            addChild(gameOver)
            playAgain = SKSpriteNode()
        } else {
            //?
        }
    }
}

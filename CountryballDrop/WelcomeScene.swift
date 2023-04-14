//
//  WelcomeScene.swift
//  CountryballDrop
//
//  Created by Doc on 4/14/23.
//
import UIKit
import SpriteKit

class WelcomeScene: SKScene {

    var playButton: SKSpriteNode!
   
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        
        playButton = SKSpriteNode(imageNamed: "gameOver")
        playButton.name = "Play!"
        playButton.zPosition = 2
        playButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        addChild(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if nodes(at: location).contains(playButton) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    [unowned self] in
                    //TODO: New Scene
                    let scene = SKScene(fileNamed: "GameScene")!
                    let transition = SKTransition.crossFade(withDuration: 1)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
    
    func populateScene(win: Bool) {
       
    }
}


//
//  EndScene.swift
//  CountryballDrop
//
//  Created by Stefan Chirica on 4/12/23.
//

import UIKit
import SpriteKit

class EndScene: SKScene {

    var win = false
    var playSoundEffects = false
    var loseSoundEffects: SKAudioNode!
    var winSoundEffects: SKAudioNode!
    var gameOver = SKSpriteNode()
    var playAgain = SKLabelNode()
    var menu = SKLabelNode()

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        populateScene(win: win, soundEffects: playSoundEffects)
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
            
            if nodes(at: location).contains(menu) {
                let scene = SKScene(fileNamed: "WelcomeScene")! as! WelcomeScene
                
                //scene.tim
                let transition = SKTransition.crossFade(withDuration: 1)
                self.view?.presentScene(scene, transition: transition)
                return
            }
        }
    }
    
    func populateScene(win: Bool, soundEffects: Bool) {
        if !win {
            gameOver = SKSpriteNode(imageNamed: "lose")
            gameOver.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
            addChild(gameOver)

        } else {
            let win = SKSpriteNode(imageNamed: "win")
            win.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
            addChild(win)
            
        }
        
        //playAgain.fontName = "Chalkduster"
        playAgain = SKLabelNode(text: "Play Again?")
        playAgain.position = CGPoint(x: self.size.width/2, y: self.size.height*0.4)
        playAgain.fontSize = 50
        playAgain.fontName = "American Typewriter"
        addChild(playAgain)
        
        menu = SKLabelNode(text: "Main Menu")
        menu.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        menu.fontSize = 40
        menu.fontName = "American Typewriter"
        addChild(menu)
        
        if let musicSoundEffectsLocation = Bundle.main.url(forResource: "lose noise", withExtension: ".mp3") {
            loseSoundEffects = SKAudioNode(url: musicSoundEffectsLocation)
            loseSoundEffects.autoplayLooped = false
            loseSoundEffects.run(SKAction.changeVolume(to: Float(0.42), duration: 0))
            addChild(loseSoundEffects)
        }
        
        if let musicSoundEffectsLocation = Bundle.main.url(forResource: "win noise", withExtension: ".mp3") {
            winSoundEffects = SKAudioNode(url: musicSoundEffectsLocation)
            winSoundEffects.autoplayLooped = false
            winSoundEffects.run(SKAction.changeVolume(to: Float(0.42), duration: 0))
            addChild(winSoundEffects)
        }
        
        if soundEffects {
            if win {
                winSoundEffects.run(SKAction.play())
            } else {
                loseSoundEffects.run(SKAction.play())
            }
        }
    }
}

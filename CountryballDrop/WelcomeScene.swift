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
    var backgroundMusic: SKAudioNode!
    var muteButton: SKSpriteNode!
    var muted = false
   
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        

        let titleButton = SKSpriteNode(imageNamed: "title")
        titleButton.name = "Title"
        //titleButton.size = CGSize(width: 400, height: 100)
        titleButton.zPosition = 2
        titleButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.65)
        addChild(titleButton)

        playButton = SKSpriteNode(imageNamed: "play")
        playButton.name = "Play"
        playButton.size = CGSize(width: 200, height: 60)
        playButton.zPosition = 2
        playButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        addChild(playButton)
        
        muteButton = SKSpriteNode(imageNamed: "unMuteMusic")
        muteButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.35)
        muteButton.zPosition = 2
        addChild(muteButton)
        
        if let musicLocation = Bundle.main.url(forResource: "kazooMusic", withExtension: ".mp3") {
            backgroundMusic = SKAudioNode(url: musicLocation)
            backgroundMusic.autoplayLooped = true
            backgroundMusic.run(SKAction.changeVolume(to: Float(0.42), duration: 0))
            addChild(backgroundMusic)
            backgroundMusic.run(SKAction.play())
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            if objects.contains(playButton) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    [unowned self] in
                    //TODO: New Scene
                    
                    let scene = SKScene(fileNamed: "GameScene") as! GameScene
                    if muted {
                        scene.muted = true
                    } else {
                        scene.muted = false
                    }
                    let transition = SKTransition.crossFade(withDuration: 1)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
            
            if objects.contains (muteButton) {
                muted = !muted
                if muted {
                    muteButton.texture = SKTexture(imageNamed: "muteMusic")
                    backgroundMusic.run(SKAction.changeVolume(to:0.0, duration: 0))
                } else {
                    muteButton.texture = SKTexture(imageNamed: "unMuteMusic")
                    backgroundMusic.run(SKAction.changeVolume(to:0.42, duration: 0))
                }
                return
            }
            
            
            
        }
    }
}


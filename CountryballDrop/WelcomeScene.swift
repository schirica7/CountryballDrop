//
//  WelcomeScene.swift
//  CountryballDrop
//
//  Created by Benjamin Hsiao on 4/14/23.
//
import UIKit
import SpriteKit
import AVFoundation

class WelcomeScene: SKScene {

    var buttonPresses = 0
    
    var playButton = SKSpriteNode()
    //var backgroundMusic = SKAudioNode()
    var player = AVAudioPlayer()
    var muteButton = SKSpriteNode()
    var nameButton = SKSpriteNode()
    var muted = false {
        didSet {
            if muted {
                muteButton.texture = SKTexture(imageNamed: "muteMusic")
                //backgroundMusic.run(SKAction.changeVolume(to:0.0, duration: 0))
                player.volume = 0
            } else {
                muteButton.texture = SKTexture(imageNamed: "unMuteMusic")
                //backgroundMusic.run(SKAction.changeVolume(to:0.42, duration: 0))
                player.volume = 0.42
            }
        }
    }
    var showNames = true {
        didSet {
            if showNames {
                nameButton.texture = SKTexture(imageNamed: "names")
            } else {
                nameButton.texture = SKTexture(imageNamed: "noNames")
            }
        }
    }
    var playSoundEffects = true
   
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        let titleButton = SKSpriteNode(imageNamed: "title")
        titleButton.name = "Title"
        titleButton.zPosition = 2
        titleButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.65)
        addChild(titleButton)

        playButton = SKSpriteNode(imageNamed: "play")
        playButton.name = "Play"
        playButton.size = CGSize(width: 200, height: 60)
        playButton.zPosition = 2
        playButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        addChild(playButton)
        
        muteButton = SKSpriteNode(texture: SKTexture(imageNamed: "unMuteMusic"))
        muteButton.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.35)
        muteButton.zPosition = 2
        addChild(muteButton)
        
        nameButton = SKSpriteNode(texture: SKTexture(imageNamed: "names"))
        nameButton.position = CGPoint(x: self.size.width * 0.65, y: self.size.height * 0.35)
        nameButton.zPosition = 2
        addChild(nameButton)
        if showNames {
            nameButton.texture = SKTexture(imageNamed: "names")
        } else {
            nameButton.texture = SKTexture(imageNamed: "noNames")
        }

        
        if let musicLocation = Bundle.main.url(forResource: "menu sound", withExtension: ".mp3") {
//            backgroundMusic = SKAudioNode(url: musicLocation)
//            backgroundMusic.autoplayLooped = true
//            addChild(backgroundMusic)
//            backgroundMusic.run(SKAction.changeVolume(to: Float(0.42), duration: 0))
//            backgroundMusic.run(SKAction.play())
            
            if muted {
                muteButton.texture = SKTexture(imageNamed: "muteMusic")
                //backgroundMusic.run(SKAction.changeVolume(to:0.0, duration: 0))
            } else {
                muteButton.texture = SKTexture(imageNamed: "unMuteMusic")
                //backgroundMusic.run(SKAction.changeVolume(to:0.42, duration: 0))
            }
        }
        
        if let vc = self.view?.window?.rootViewController {
            let gameVC = vc as! GameViewController
            gameVC.banner.isAutoloadEnabled = true
            gameVC.banner.isHidden = false
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            
            if objects.contains(playButton) && buttonPresses == 0 {
                buttonPresses += 1
                playButton.alpha = 0.5
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    [unowned self] in
                    self.playButton.alpha = 1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    [unowned self] in
                    
                    let scene = SKScene(fileNamed: "GameScene") as! GameScene
                    scene.muted = muted
                    scene.showNames = showNames
                    scene.playSoundEffects = playSoundEffects
                    
                    let transition = SKTransition.crossFade(withDuration: 2)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
            
            if objects.contains (muteButton) {
                muted = !muted
                return
            }
            
            if objects.contains (nameButton) {
                showNames = !showNames
                return
            }
        }
    }
}


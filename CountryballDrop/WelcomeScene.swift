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
    var playButton = SKSpriteNode()
    var backgroundMusic = SKAudioNode()
    
    var player = AVAudioPlayer()
    var muteButton = SKSpriteNode()
    var nameButton = SKSpriteNode()
    var muted = false {
        didSet {
            if muted {
                muteButton.texture = SKTexture(imageNamed: "muteMusic")
                player.volume = 0
            } else {
                muteButton.texture = SKTexture(imageNamed: "unMuteMusic")
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

        
        /*if let musicLocation = Bundle.main.url(forResource: "menu sound", withExtension: ".mp3") {
            backgroundMusic = SKAudioNode(url: musicLocation)
            backgroundMusic.autoplayLooped = true
            backgroundMusic.run(SKAction.changeVolume(to: Float(0.42), duration: 0))
            addChild(backgroundMusic)
            backgroundMusic.run(SKAction.play())
            
            if muted {
                muteButton.texture = SKTexture(imageNamed: "muteMusic")
                backgroundMusic.run(SKAction.changeVolume(to:0.0, duration: 0))
            } else {
                muteButton.texture = SKTexture(imageNamed: "unMuteMusic")
                backgroundMusic.run(SKAction.changeVolume(to:0.42, duration: 0))
            }
        }*/
        if let vc = self.view?.window?.rootViewController {
            let gameVC = vc as! GameViewController
            gameVC.banner.isAutoloadEnabled = true
            gameVC.banner.isHidden = false
            
            //player.delegate = gameVC
        }
        
        let soundName = "menu sound"
        if let asset = NSDataAsset(name: soundName) {
            do {
                player = try AVAudioPlayer(data: asset.data, fileTypeHint: "mp3")
                player.play()
                player.volume = 0.42
                player.numberOfLoops = -1
            } catch let error as NSError {
                print("This is an error")
                print(error.localizedDescription)
            }
        }
        
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.allowBluetooth])
//            try AVAudioSession.sharedInstance().setActive(true)
//            
//            NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(_:)), name: AVAudioSession.interruptionNotification, object: nil)
//        } catch {
//            // Handle the error
//            print("Something happened")
//        }

        
    }
    
    override func willMove(from: SKView) {
        // Pause your audio playback
        print("Your mom")
        player.pause()
    }

    override func sceneDidLoad() {
        // Resume your audio playback
        player.play()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            if objects.contains(playButton) {
                playButton.alpha = 0.5
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    [unowned self] in
                    playButton.alpha = 1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    [unowned self] in
                    //TODO: New Scene
                    player.stop()
                    let scene = SKScene(fileNamed: "GameScene") as! GameScene
                    scene.bgPlayer.stop()
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
    
//    @objc func handleInterruption(_ notification: Notification) {
//            guard let userInfo = notification.userInfo,
//                  let interruptionType = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else {
//                return
//            }
//
//            switch AVAudioSession.InterruptionType(rawValue: interruptionType)! {
//            case .began:
//                // Handle interruption began
//                print("Audio interrupted")
//                player.pause()
//            case .ended:
//                player.play()
//                do {
//                    try AVAudioSession.sharedInstance().setActive(true)
//                } catch {
//                    // Handle the error
//                    print("Audio session error")
//                }
//            @unknown default:
//                print("Unknown audio session error")
//            }
//        }
    
    func pauseAudio() {
        player.pause()
    }
    
    func playAudio() {
        player.play()
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
//    }
}


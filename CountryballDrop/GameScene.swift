//
//  GameScene.swift
//  CountryballDrop
//
//  Created by Stefan Chirica on 3/14/23.
//

import SpriteKit
import GameplayKit

/*
 TODO: Menu button - music, restart, exit
 TODO: Music✅
 TODO: Intro & Outro Scene With Graphics
 TODO: If you have a world, you win - 1/2
 TODO: Timer ✅
 TODO: Emitter cell when combine
 
 I actually made a game though
 */
class GameScene: SKScene, SKPhysicsContactDelegate {
    //MARK: Variables
    private var label : SKLabelNode?
    var timerLabel = SKLabelNode(text: "Time: 0:00")
    var minutes = 0
    var hours = 0
    var counter = 0 {
        didSet {
            if counter >= 60 {
                minutes += 1
                counter = 0
                if minutes >= 60 {
                    hours += 1
                    minutes = 0
                }
            }
            self.timerLabel.text = String(format: "Time: %02d:%02d:%02d", hours, minutes, counter)
        }
    }
    
    var spawnHeight = 0.87
    var maxHeight = 0.8
    var warningHeight = 0.6
    var balls = [Countryball]()
    let names = ["vatican", "luxembourg", "netherlands", "ireland", "uk",
                 "poland", "germany", "ukraine", "russia", "world"]
    var inMenu = false
    var showNames = true
    
    var backgroundMusic: SKAudioNode!
    var muteButton: SKSpriteNode!
    var muted = false
    
    var soundEffects: SKAudioNode!
    var muteSoundEffectsButton: SKSpriteNode!
    var mutedSoundEffects = false
    var playSoundEffects = true
    
    var max: SKNode!
    var warning: SKNode!
    
    var resetButton: SKSpriteNode!
    //To lose: if the ball's y + ball.height/2 >= max height
    //Warning: if the ball's y + ball.height/2 >= warning height
    
    func count() {
        counter += 1
    }
    
    override func didMove(to view: SKView) {
        //MARK: Setting up the map
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        
        let bottomSize = CGSize(width: self.size.width, height: self.size.height * 0.11)
        let bottom = SKSpriteNode(color: UIColor(red: 255/255, green: 210/255, blue: 79/255, alpha: 1), size: bottomSize)
        bottom.name = "bottom"
        bottom.physicsBody = SKPhysicsBody(rectangleOf: bottomSize)
        bottom.physicsBody!.isDynamic = false
        bottom.zPosition = -1
        bottom.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.055)
        addChild(bottom)
        
        let warningSize = CGSize(width: self.size.width, height: 5)
        warning = SKSpriteNode(color: UIColor(red: 1, green: 0, blue: 0, alpha: 1), size: warningSize)
        warning.zPosition = -1
        warning.position = CGPoint(x: self.size.width/2, y: self.size.height * warningHeight)
        warning.isHidden = true
        warning.name = "warning"
        addChild(warning)
        
        max = SKSpriteNode(color: UIColor(red: 1, green: 0, blue: 0, alpha: 1), size: warningSize)
        max.zPosition = -1
        max.position = CGPoint(x: self.size.width/2, y: self.size.height * maxHeight)
        max.isHidden = true
        max.name = "max"
        addChild(max)
        
        spawnTopCB(at: CGPoint(x: self.size.width/2, y: self.size.height * spawnHeight))
        
        muteButton = SKSpriteNode(imageNamed: "unMuteMusic")
        muteButton.size = CGSize(width: 60, height: 60)
        muteButton.position = CGPoint(x: self.size.width * 0.87, y: self.size.height * 0.95)
        muteButton.zPosition = 2
        addChild(muteButton)
        
        //MARK: Background music
        if let musicLocation = Bundle.main.url(forResource: "menu sound", withExtension: ".mp3") {
            backgroundMusic = SKAudioNode(url: musicLocation)
            backgroundMusic.autoplayLooped = true
            addChild(backgroundMusic)
            backgroundMusic.run(SKAction.play())
            
            if muted {
                muteButton.texture = SKTexture(imageNamed: "muteMusic")
                backgroundMusic.run(SKAction.changeVolume(to:0.0, duration: 0))
            } else {
                muteButton.texture = SKTexture(imageNamed: "unMuteMusic")
                backgroundMusic.run(SKAction.changeVolume(to:0.42, duration: 0))
            }
        }
        
        //MARK: Sound Effects
        muteSoundEffectsButton = SKSpriteNode(imageNamed: "UnmuteButton")
        muteSoundEffectsButton.size = CGSize(width: 60, height: 60)
        muteSoundEffectsButton.position = CGPoint(x: self.size.width * 0.13, y: self.size.height * 0.95)
        muteSoundEffectsButton.zPosition = 2
        addChild(muteSoundEffectsButton)
        
        if let musicSoundEffectsLocation = Bundle.main.url(forResource: "sound effect #1", withExtension: ".mp3") {
            soundEffects = SKAudioNode(url: musicSoundEffectsLocation)
            soundEffects.autoplayLooped = false
            soundEffects.run(SKAction.changeVolume(to: Float(0.30), duration: 0))
            addChild(soundEffects)
        }
        
        resetButton = SKSpriteNode(imageNamed: "reset")
        resetButton.size = CGSize(width: 68, height: 68)
        resetButton.position = CGPoint(x: self.size.width * 0.87, y: self.size.height * 0.85)
        resetButton.zPosition = 2
        addChild(resetButton)
        
        timerLabel = SKLabelNode(fontNamed: "American Typewriter")
        timerLabel.text = "Score: 0"
        timerLabel.horizontalAlignmentMode = .center
        timerLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.93)
        self.timerLabel.fontSize = 20
        self.addChild(timerLabel)
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(count), SKAction.wait(forDuration: 1)])))
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            
            //MARK: Touching Mute Button
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
            
            //MARK: Touching Reset Button
            //Reset button removes all balls, starts music back at the beginning, and carries over settings from previous game
            if objects.contains (resetButton) {
                //TODO: Pause timer when alert controller is showing, restart if hit no
                let ac = UIAlertController(title: "Reset Game", message: "Are you sure you want to reset your game?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: resetGame))
                ac.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                ac.addAction(UIAlertAction(title: "Menu", style: .default, handler: mainMenu))
                view?.window?.rootViewController?.present(ac, animated: true)
                return
            }
            
            //MARK: Touching Sound Effects Button
            if objects.contains (muteSoundEffectsButton) {
                mutedSoundEffects = !mutedSoundEffects
                if mutedSoundEffects {
                    muteSoundEffectsButton.texture = SKTexture(imageNamed: "MuteButton")
                    playSoundEffects = false
                } else {
                    muteSoundEffectsButton.texture = SKTexture(imageNamed: "UnmuteButton")
                    playSoundEffects = true
                }
                return
            }
            
            for node in children {
                if node.name == "ready" {
                    let cb = node as! Countryball
                    cb.position = CGPoint(x: location.x, y: node.position.y)
                    cb.physicsBody!.isDynamic = true
                    cb.physicsBody!.restitution = 0.005
                    cb.ballNode.name = "ball"
                    cb.name = "ball"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        [unowned self] in
                        self.spawnTopCB(at: CGPoint(x: self.size.width/2, y: self.size.height * spawnHeight))
                    }
                    
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //MARK: Collisions
        if contact.bodyA.node?.name == "ball" && (contact.bodyB.node?.name == "bottom" || contact.bodyB.node?.name == "ball") {
            let cb = contact.bodyA.node! as! Countryball
            cb.dropped = true
            if showNames && !cb.nameShown {
                showName(cb: cb)
                cb.nameShown = true
            }
            print("Dropped: \(cb.dropped)")
            
            if contact.bodyB.node?.name == "ball" {
                let cb1 = contact.bodyB.node! as! Countryball
                cb1.dropped = true
                
                if showNames && !cb1.nameShown {
                    showName(cb: cb1)
                    cb1.nameShown = true
                }
                
                print("Dropped: \(cb1.dropped)")
                collisionBetween(cb: cb, object: contact.bodyB.node!)
            } else {
                let velocity = CGVector(dx: cb.physicsBody!.mass * 1.5 * CGFloat(leftOrRight()), dy: cb.physicsBody!.mass * 1.5)
                cb.run(SKAction.applyForce(velocity, duration: 1))
            }
        } else if (contact.bodyA.node?.name == "bottom" || contact.bodyA.node?.name == "ball") && contact.bodyB.node?.name == "ball" {
            let cb = contact.bodyB.node! as! Countryball
            cb.dropped = true
            
            if showNames && !cb.nameShown {
                showName(cb: cb)
                cb.nameShown = true
            }
            print(cb.dropped)
            
            if contact.bodyA.node?.name == "ball" {
                let cb1 = contact.bodyA.node! as! Countryball
                cb1.dropped = true
                
                if showNames && !cb1.nameShown {
                    showName(cb: cb1)
                    cb1.nameShown = true
                }
                print("Dropped: \(cb1.dropped)")
                collisionBetween(cb: cb, object: contact.bodyA.node!)
            } else {
                let velocity = CGVector(dx: cb.physicsBody!.mass * 1.5 * CGFloat(leftOrRight()), dy: cb.physicsBody!.mass * 1.5)
                cb.run(SKAction.applyForce(velocity, duration: 1))
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (_, node) in self.children.enumerated() {
            if node.name == "ball" {
                let cBall = node as! Countryball
                
                if cBall.position.y + cBall.ballSize/2 < max.position.y - 2.5 {
                    if !cBall.dropped {
                        cBall.dropped = true
                    }
                } else {
                    if cBall.dropped {
                        let scene = SKScene(fileNamed: "EndScene")! as! EndScene
                        scene.playSoundEffects = playSoundEffects
                        let transition = SKTransition.crossFade(withDuration: 1)
                        self.view?.presentScene(scene, transition: transition)
                    }
                }
                
                if node.position.y >= warning.position.y && node.physicsBody!.velocity.dy >= 0  {
                    let cb = node as! Countryball
                    if cb.dropped {
                        if max.isHidden {
                            max.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    func collisionBetween(cb: Countryball?, object: SKNode?) {
        if object?.name == "ball" && cb?.name == "ball" {
            let cb2 = object as! Countryball
            
            if showNames && !cb2.nameShown {
                showName(cb: cb2)
                cb2.nameShown = true
            }
            
            if (cb!.ballName == cb2.ballName && cb2.ballName != "world") {
                let newX = (cb!.position.x + cb2.position.x)/2.0
                let newY = (cb!.position.y + cb2.position.y)/2.0
                
                combineCB(cb1: cb!, cb2: cb2, at: CGPoint(x: newX, y: newY))
                if playSoundEffects {
                    soundEffects.run(SKAction.play())
                }
                
            }
        }
    }
    
    func combineCB(cb1: Countryball, cb2: Countryball, at position: CGPoint) {
        var newCBName = ""
        
        for (index, name) in names.enumerated() {
            if name == cb1.ballName && name == cb2.ballName {
                newCBName = names[index + 1]
                destroyBall(ball: cb1)
                destroyBall(ball: cb2)
                
                
                let newBall = Countryball()
                newBall.spawn(at: position, named: newCBName)
                newBall.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(newBall.ballSize)/2.0)
                newBall.physicsBody!.isDynamic = true
                newBall.physicsBody!.contactTestBitMask = newBall.physicsBody!.collisionBitMask
                addChild(newBall)
                newBall.name = "ball"
                newBall.ballNode.name = "ball"
                let velocity = CGVector(dx: newBall.physicsBody!.mass * 1.5 * CGFloat(leftOrRight()), dy: newBall.physicsBody!.mass * 1.5)
                newBall.run(SKAction.applyForce(velocity, duration: 1))
                if showNames && !newBall.nameShown {
                    showName(cb: newBall)
                    newBall.nameShown = true
                }
                
                if let fireParticles = SKEmitterNode(fileNamed: "Spark") {
                    fireParticles.position = newBall.position
                        fireParticles.name = "fireParticles"
                        addChild(fireParticles)
                }
            
                newBall.dropped = true
                
                let scene = SKScene(fileNamed: "EndScene")! as! EndScene
                
                if newCBName == "world" && (newBall.position.y + newBall.ballSize/2 < max.position.y - 2.5){
                    scene.win = true
                    scene.playSoundEffects = playSoundEffects
                    let transition = SKTransition.crossFade(withDuration: 1)
                    self.view?.presentScene(scene, transition: transition)
                } else if newBall.position.y + newBall.ballSize/2 >= max.position.y - 2.5 {
                    scene.win = false
                    scene.playSoundEffects = playSoundEffects
                    let transition = SKTransition.crossFade(withDuration: 1)
                    self.view?.presentScene(scene, transition: transition)
                }
                
                break
            }
        }
    }
    
    func showName(cb: Countryball) {
        var cbName = ""
        
        if cb.ballName == "uk" {
            cbName = "UK"
        } else if cb.ballName == "vatican"{
            cbName = "Vatican City"
        } else {
            cbName = cb.ballName.capitalized
        }
        
        let name = SKLabelNode(fontNamed: "American Typewriter")
        name.text = cbName
        name.position = CGPoint(x: cb.position.x, y: cb.position.y + cb.ballSize*1.05)
        name.zPosition = 5
        addChild(name)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            [unowned self] in
            name.removeFromParent()
        }
    }
    
    func destroyBall(ball: SKNode?) {
        ball?.removeFromParent()
    }
    
    func spawnTopCB(at position: CGPoint) {
        let ball = Countryball()
        ball.spawn(at: position, named: ball.newCbName())
        ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(ball.ballSize)/2.0)
        ball.physicsBody!.isDynamic = false
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        addChild(ball)
        ball.name = "ready"
        ball.ballNode.name = "ball"
    }
    
    func leftOrRight() -> Int {
        let right = Bool.random()
        var direction = 0
        
        if !right {
            direction = -1
        } else {
            direction = 1
        }
        
        return direction
    }
    
    @objc func resetGame(action: UIAlertAction!) {
        counter = 0
        minutes = 0
        hours = 0
        
        timerLabel.text = "Time: 00:00:00"
        
        for node in self.children {
            if node.name == "ball" || node.name == "ready" {
                node.removeFromParent()
            }
        }
        
        spawnTopCB(at: CGPoint(x: self.size.width/2, y: self.size.height * spawnHeight))
        
        if let musicLocation = Bundle.main.url(forResource: "menu sound", withExtension: ".mp3") {
            backgroundMusic.run(SKAction.stop())
            backgroundMusic = SKAudioNode(url: musicLocation)
            backgroundMusic.autoplayLooped = true
            addChild(backgroundMusic)
            backgroundMusic.run(SKAction.play())
            
            if muted {
                muteButton.texture = SKTexture(imageNamed: "muteMusic")
                backgroundMusic.run(SKAction.changeVolume(to:0.0, duration: 0))
            } else {
                muteButton.texture = SKTexture(imageNamed: "unMuteMusic")
                backgroundMusic.run(SKAction.changeVolume(to:0.42, duration: 0))
            }
        }
    }
    
    @objc func mainMenu(action: UIAlertAction!) {
        let scene = SKScene(fileNamed: "WelcomeScene")! as! WelcomeScene
        //scene.muted = muted
        let transition = SKTransition.crossFade(withDuration: 1)
        self.view?.presentScene(scene, transition: transition)
    }
    
    /*func intersectsMax(cb: Countryball) -> Bool {
        (newBall.position.y + newBall.frame.size.height/2 >= max.position.y - 2.5
                   && newBall.position.y + newBall.frame.size.height/2 >= max.position.y + 2.5)
    }*/
}

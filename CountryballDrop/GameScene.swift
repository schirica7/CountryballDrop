//
//  GameScene.swift
//  CountryballDrop
//
//  Created by Stefan Chirica on 3/14/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    //MARK: Variables
    private var label = SKLabelNode()
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
    
    var spawnHeight = 0.85
    var maxHeight = 0.8
    var warningHeight = 0.6
    var balls = [Countryball]()
    let names = ["vatican", "luxembourg", "netherlands", "ireland", "uk",
                 "poland", "germany", "ukraine", "russia", "world"]
    var inMenu = false
    
    var showNames = true
    var nameButton = SKSpriteNode()
    
    var backgroundMusic = SKAudioNode()
    var muteButton = SKSpriteNode()
    var muted = false
    
    var soundEffects = SKAudioNode()
    var muteSoundEffectsButton = SKSpriteNode()
    var mutedSoundEffects = false
    var playSoundEffects = true
    
    var max = SKNode()
    var warning = SKNode()
    
    let feedbackGen = UINotificationFeedbackGenerator()
    
    
    var resetButton = SKSpriteNode()
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
        
        muteButton = SKSpriteNode(texture: SKTexture(imageNamed: "unMuteMusic"))
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
        muteSoundEffectsButton.position = CGPoint(x: self.size.width * 0.13, y: self.size.height * 0.85)
        muteSoundEffectsButton.zPosition = 2
        addChild(muteSoundEffectsButton)
        
        if let musicSoundEffectsLocation = Bundle.main.url(forResource: "sound effect #1", withExtension: ".aiff") {
            soundEffects = SKAudioNode(url: musicSoundEffectsLocation)
            soundEffects.autoplayLooped = false
            soundEffects.run(SKAction.changeVolume(to: Float(0.30), duration: 0))
            addChild(soundEffects)
            
            if mutedSoundEffects {
                muteSoundEffectsButton.texture = SKTexture(imageNamed: "MuteButton")
                playSoundEffects = false
            } else {
                muteSoundEffectsButton.texture = SKTexture(imageNamed: "UnmuteButton")
                playSoundEffects = true
            }
        }
        
        //MARK: Country Names
        nameButton = SKSpriteNode(texture: SKTexture(imageNamed: "names"))
        nameButton.size = CGSize(width: 60, height: 60)
        nameButton.position = CGPoint(x: self.size.width * 0.13, y: self.size.height * 0.95)
        nameButton.zPosition = 2
        addChild(nameButton)
        
        if showNames {
            nameButton.texture = SKTexture(imageNamed: "names")
        } else {
            nameButton.texture = SKTexture(imageNamed: "noNames")
        }
        
        resetButton = SKSpriteNode(imageNamed: "reset")
        resetButton.size = CGSize(width: 68, height: 68)
        resetButton.position = CGPoint(x: self.size.width * 0.87, y: self.size.height * 0.85)
        resetButton.zPosition = 2
        addChild(resetButton)
        
        timerLabel = SKLabelNode(fontNamed: "American Typewriter")
        timerLabel.text = "Score: 0"
        timerLabel.horizontalAlignmentMode = .center
        timerLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.923)
        self.timerLabel.fontSize = 20
        self.addChild(timerLabel)
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(count), SKAction.wait(forDuration: 1)])))
        
        if let vc = self.view?.window?.rootViewController {
            let gameVC = vc as! GameViewController
            gameVC.banner.backgroundColor = UIColor(red: 255/255, green: 210/255, blue: 79/255, alpha: 1)
            gameVC.banner.isAutoloadEnabled = true
            gameVC.banner.isHidden = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            
            //MARK: Touching Mute Button
            if objects.contains (muteButton) {
                return
            }


            //MARK: Touching Sound Effects Button
            if objects.contains (muteSoundEffectsButton) {
                return
            }

            if objects.contains(nameButton) {
                return
            }
            
            //MARK: Touching Reset Button
            //Reset button removes all balls, starts music back at the beginning, and carries over settings from previous game
            if objects.contains (resetButton) {
                //TODO: Pause timer when alert controller is showing, restart if hit no
                return
            }
            
            for node in children {
                if node.name == "ready" {
                    //let cb = node as! Countryball
//                    cb.ballNode.position = CGPoint(x: location.x, y: node.position.y)
//                    cb.ballNode.physicsBody!.isDynamic = true
//                    cb.ballNode.physicsBody!.restitution = 0.005
//                    cb.ballNode.name = "ball"
                    //cb.name = "ball"
                    
                    node.position = CGPoint(x: location.x, y: node.position.y)
                    node.physicsBody!.isDynamic = true
                    node.physicsBody!.restitution = 0.005
                    node.name = "ball"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        [unowned self] in
                        self.spawnTopCB(at: CGPoint(x: self.size.width/2, y: self.size.height * spawnHeight))
                    }
                    
                }
            }
        }
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
            
            if objects.contains(nameButton) {
                showNames = !showNames
                
                if showNames {
                    nameButton.texture = SKTexture(imageNamed: "names")
                } else {
                    nameButton.texture = SKTexture(imageNamed: "noNames")
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
        }
        
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        //MARK: Collisions
        if contact.bodyA.node?.name == "ball" && (contact.bodyB.node?.name == "bottom" || contact.bodyB.node?.name == "ball") {
            
            if let cb = getCountryball(node: contact.bodyA.node!) {
                cb.dropped = true
                
                if showNames && !cb.nameShown {
                    showName(cb: cb)
                }
                
                cb.nameShown = true
                
                if contact.bodyB.node?.name == "ball" {
                    if let cb1 = getCountryball(node: contact.bodyB.node!) {

                        cb1.dropped = true
                        
                        if showNames && !cb1.nameShown {
                            showName(cb: cb1)
                        }
                        
                        cb1.nameShown = true
                        collisionBetween(cb: cb, object: contact.bodyB.node!)
                    }
                } else {
                    let velocity = CGVector(dx: cb.ballNode.physicsBody!.mass * 1.5 * CGFloat(leftOrRight()), dy: cb.ballNode.physicsBody!.mass * 1.5)
                    cb.ballNode.run(SKAction.applyForce(velocity, duration: 1))
                }
            }
        } else if (contact.bodyA.node?.name == "bottom" || contact.bodyA.node?.name == "ball") && contact.bodyB.node?.name == "ball" {
            if let cb = getCountryball(node: contact.bodyB.node! as! SKSpriteNode) {
                cb.dropped = true
                
                if showNames && !cb.nameShown {
                    showName(cb: cb)
                }
                
                cb.nameShown = true
                
                if contact.bodyA.node?.name == "ball" {
                    if let cb1 = getCountryball(node: contact.bodyA.node!) {
                        cb1.dropped = true
                        
                        if showNames && !cb1.nameShown {
                          showName(cb: cb1)
                        }
                        
                        cb1.nameShown = true
                        collisionBetween(cb: cb, object: contact.bodyA.node!)
                    }
                } else {
                    let velocity = CGVector(dx: cb.ballNode.physicsBody!.mass * 1.5 * CGFloat(leftOrRight()), dy: cb.ballNode.physicsBody!.mass * 1.5)
                    cb.ballNode.run(SKAction.applyForce(velocity, duration: 1))
                }
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (_, node) in self.children.enumerated() {
            if node.name == "ball" {
                
                if let cBall = getCountryball(node: node) {
                    
                    if cBall.ballNode.position.y + cBall.ballSize/2 < max.position.y - 2.5 {
                        if !cBall.dropped {
                            cBall.dropped = true
                        }
                    } else {
                        if cBall.dropped {
                            let scene = SKScene(fileNamed: "EndScene")! as! EndScene
                            scene.playSoundEffects = playSoundEffects
                            scene.muted = muted
                            scene.showNames = showNames
                            let transition = SKTransition.crossFade(withDuration: 1)
                            self.view?.presentScene(scene, transition: transition)
                        }
                    }
                }
                
                if node.position.y >= warning.position.y && node.physicsBody!.velocity.dy >= 0  {
                    if let cb = getCountryball(node: node) {
                        if cb.dropped {
                            if max.isHidden {
                                max.isHidden = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    func collisionBetween(cb: Countryball?, object: SKNode?) {
        /*if playSoundEffects {
            feedbackGen.notificationOccurred(.success)
        }*/
        
        if object?.name == "ball" && cb?.ballNode.name == "ball" {
            if let cb2 = getCountryball(node: object!) {
                
                if (cb!.ballName == cb2.ballName && cb2.ballName != "world") {
                    let newX = (cb!.ballNode.position.x + cb2.ballNode.position.x)/2.0
                    let newY = (cb!.ballNode.position.y + cb2.ballNode.position.y)/2.0
                    
                    
                    destroyBall(ball: cb!)
                    destroyBall(ball: cb2)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        [unowned self] in
                        
                        combineCB(cb1: cb!, cb2: cb2, at: CGPoint(x: newX, y: newY))
                        
                        if playSoundEffects {
                            soundEffects.run(SKAction.play())
                        }
                        /*if showNames && !cb2.nameShown {
                         showName(cb: cb2)
                         cb2.nameShown = true
                         }*/
                    }
                    
                }
            }
        }
    }
    
    func combineCB(cb1: Countryball, cb2: Countryball, at position: CGPoint) {
        var newCBName = ""
        
        for (index, name) in names.enumerated() {
            if name == cb1.ballName && name == cb2.ballName {
                newCBName = names[index + 1]
                
                
                //TODO: new countryballs
                let newBall = Countryball()
                newBall.spawn(at: position, named: newCBName)
                newBall.ballNode.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(newBall.ballSize)/2.0)
                newBall.ballNode.physicsBody!.isDynamic = true
                newBall.ballNode.physicsBody!.contactTestBitMask = newBall.ballNode.physicsBody!.collisionBitMask
                addChild(newBall.ballNode)
                balls.append(newBall)
                //newBall.name = "ball"
                newBall.ballNode.name = "ball"
                let velocity = CGVector(dx: newBall.ballNode.physicsBody!.mass * 1.5 * CGFloat(leftOrRight()), dy: newBall.ballNode.physicsBody!.mass * 1.5)
                newBall.ballNode.run(SKAction.applyForce(velocity, duration: 1))
                if showNames && !newBall.nameShown {
                    showName(cb: newBall)
                    newBall.nameShown = true
                }
                
                if let fireParticles = SKEmitterNode(fileNamed: "Spark") {
                    fireParticles.position = newBall.ballNode.position
                        fireParticles.name = "fireParticles"
                        addChild(fireParticles)
                }
            
                newBall.dropped = true
                
                let scene = SKScene(fileNamed: "EndScene")! as! EndScene
                
                if newCBName == "world" && (newBall.ballNode.position.y + newBall.ballSize/2 < max.position.y - 2.5){
                    scene.win = true
                    scene.muted = muted
                    scene.showNames = showNames
                    scene.playSoundEffects = playSoundEffects
                    let transition = SKTransition.crossFade(withDuration: 1)
                    self.view?.presentScene(scene, transition: transition)
                } else if newBall.ballNode.position.y + newBall.ballSize/2 >= max.position.y - 2.5 {
                    scene.win = false
                    scene.muted = muted
                    scene.showNames = showNames
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
        name.position = CGPoint(x: cb.ballNode.position.x, y: cb.ballNode.position.y + cb.ballSize*1.05)
        name.zPosition = 5
        addChild(name)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        [unowned self] in
            name.removeFromParent()
        }
    }
    
    func destroyBall(ball: Countryball) {
        //Remove countryballs from array
        for (index, ball1) in balls.enumerated() {
            if ball.ballNode.position == ball1.ballNode.position {
                balls.remove(at: index)
            }
        }
        
        ball.ballNode.removeFromParent()
        ball.ballNode = nil
    }
    
    func spawnTopCB(at position: CGPoint) {
        let ball = Countryball()
        ball.spawn(at: position, named: ball.newCbName())
        ball.ballNode.name = "ready"
        addChild(ball.ballNode)
        balls.append(ball)
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
    
    func getCountryball(node: SKNode) -> Countryball? {
        for ball in balls {
            if node.position == ball.ballNode.position {
                return ball
            }
        }
        return nil
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
        balls.removeAll()
        
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
        for node in self.children {
            if node.name == "ball" || node.name == "ready" {
                node.removeFromParent()
            }
        }
        balls.removeAll()
        
        let scene = SKScene(fileNamed: "WelcomeScene")! as! WelcomeScene
        scene.muted = muted
        scene.showNames = showNames
        scene.playSoundEffects = playSoundEffects
        let transition = SKTransition.crossFade(withDuration: 1)
        self.view?.presentScene(scene, transition: transition)
    }
}

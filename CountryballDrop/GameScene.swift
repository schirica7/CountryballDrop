//
//  GameScene.swift
//  CountryballDrop
//
//  Created by Stefan Chirica on 3/14/23.
//

import SpriteKit
import GameplayKit
import GoogleMobileAds

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
    
    var balls = [Countryball]() {
        didSet {
            print("balls: \(balls)")
        }
    }
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
        muteButton.name = "mute"
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
        muteSoundEffectsButton.name = "muteSoundEffects"
        muteSoundEffectsButton.size = CGSize(width: 60, height: 60)
        muteSoundEffectsButton.position = CGPoint(x: self.size.width * 0.13, y: self.size.height * 0.85)
        muteSoundEffectsButton.zPosition = 2
        addChild(muteSoundEffectsButton)
        
        if let musicSoundEffectsLocation = Bundle.main.url(forResource: "sound effect #1", withExtension: ".aiff") {
            soundEffects = SKAudioNode(url: musicSoundEffectsLocation)
            soundEffects.autoplayLooped = false
            soundEffects.run(SKAction.changeVolume(to: Float(0.70), duration: 0))
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
        nameButton.name = "name"
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
        resetButton.name = "reset"
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        muteButton.isHidden = false
        muteSoundEffectsButton.isHidden = false
        nameButton.isHidden = false
        resetButton.isHidden = false
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            //MARK: Touching Mute Button
            
            if objects.contains(muteButton) {
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
            if objects.contains(muteSoundEffectsButton) {
                print("hello")
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        muteButton.isHidden = false
        muteSoundEffectsButton.isHidden = false
        nameButton.isHidden = false
        resetButton.isHidden = false
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            
            if !objects.contains(muteButton)
                && !objects.contains(muteSoundEffectsButton)
                && !objects.contains(resetButton)
                && !objects.contains(nameButton) {
                for node in children {
                    if node.name == "ready" {
                        node.position = CGPoint(x: location.x, y: node.position.y)
                        if node.position.x < node.frame.size.width/2 {
                            node.position = CGPoint(x: node.frame.size.width/2, y: node.position.y)
                        }
                        
                        if node.position.x > (self.size.width - node.frame.size.width/2) {
                            node.position = CGPoint(x: (self.size.width - node.frame.size.width/2), y: node.position.y)
                        }
                        dropCB(node: node)
                    }
                }
            } else if objects.contains(muteSoundEffectsButton) {
                for node in children {
                    if node.name == "ready" && objects.contains(node){
                        node.position = CGPoint(x: location.x, y: node.position.y)
                        if node.position.x < node.frame.size.width/2 {
                            node.position = CGPoint(x: node.frame.size.width/2, y: node.position.y)
                        }
                        
                        if node.position.x > (self.size.width - node.frame.size.width/2) {
                            node.position = CGPoint(x: (self.size.width - node.frame.size.width/2), y: node.position.y)
                        }
                        dropCB(node: node)
                    }
                }
            } else if objects.contains(resetButton) {
                for node in children {
                    if node.name == "ready" && objects.contains(node) {
                        node.position = CGPoint(x: location.x, y: node.position.y)
                        if node.position.x < node.frame.size.width/2 {
                            node.position = CGPoint(x: node.frame.size.width/2, y: node.position.y)
                        }
                        
                        if node.position.x > (self.size.width - node.frame.size.width/2) {
                            node.position = CGPoint(x: (self.size.width - node.frame.size.width/2), y: node.position.y)
                        }
                        dropCB(node: node)
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            
            for node in children {
                if node.name == "ready" {
                    if !objects.contains(muteButton)
                        && !objects.contains(muteSoundEffectsButton)
                        && !objects.contains(resetButton)
                        && !objects.contains(nameButton){
                        muteButton.isHidden = true
                        muteSoundEffectsButton.isHidden = true
                        nameButton.isHidden = true
                        resetButton.isHidden = true
                        
                        if let cb = getCountryball(node: node) {
                            node.position = CGPoint(x: location.x, y: node.position.y)
                            if node.position.x < node.frame.size.width/2 {
                                node.position = CGPoint(x: node.frame.size.width/2, y: node.position.y)
                            }
                            
                            if node.position.x > (self.size.width - node.frame.size.width/2) {
                                node.position = CGPoint(x: (self.size.width - node.frame.size.width/2), y: node.position.y)
                            }
                            return
                        }
                    }
                }
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
                
                if playSoundEffects && !cb.hapticsActivated {
                    feedbackGen.notificationOccurred(.success)
                    cb.hapticsActivated = true
                }
                
                
                if contact.bodyB.node?.name == "ball" {
                    if let cb1 = getCountryball(node: contact.bodyB.node!) {
                        
                        cb1.dropped = true
                        //cb1.hapticsActivated = true
                        
                        if showNames && !cb1.nameShown {
                            showName(cb: cb1)
                        }
                        
                        if playSoundEffects && !cb1.hapticsActivated {
                            feedbackGen.notificationOccurred(.success)
                            cb1.hapticsActivated = true
                        }
                        
                        cb1.nameShown = true
                        collisionBetween(cb: cb, object: contact.bodyB.node!)
                    }
                } else {
                    if let ballNode = cb.ballNode {
                        let velocity = CGVector(dx: ballNode.physicsBody!.mass * 1.5 * CGFloat(leftOrRight()), dy: ballNode.physicsBody!.mass * 1.5)
                        ballNode.run(SKAction.applyForce(velocity, duration: 1))
                    }
                }
            }
        } else if (contact.bodyA.node?.name == "bottom" || contact.bodyA.node?.name == "ball") && contact.bodyB.node?.name == "ball" {
            if let cb = getCountryball(node: contact.bodyB.node! as! SKSpriteNode) {
                cb.dropped = true
                
                if showNames && !cb.nameShown {
                    showName(cb: cb)
                }
                
                cb.nameShown = true
                
                if playSoundEffects && !cb.hapticsActivated {
                    feedbackGen.notificationOccurred(.success)
                    cb.hapticsActivated = true
                }
                
                if contact.bodyA.node?.name == "ball" {
                    if let cb1 = getCountryball(node: contact.bodyA.node!) {
                        cb1.dropped = true
                        //cb1.hapticsActivated = true
                        if playSoundEffects && !cb1.hapticsActivated {
                            feedbackGen.notificationOccurred(.success)
                            cb1.hapticsActivated = true
                        }
                        
                        if showNames && !cb1.nameShown {
                            showName(cb: cb1)
                        }
                        
                        cb1.nameShown = true
                        collisionBetween(cb: cb, object: contact.bodyA.node!)
                    }
                } else {
                    if let ballNode = cb.ballNode {
                        let velocity = CGVector(dx: ballNode.physicsBody!.mass * 1.5 * CGFloat(leftOrRight()), dy: ballNode.physicsBody!.mass * 1.5)
                        ballNode.run(SKAction.applyForce(velocity, duration: 1))
                    }
                }
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (_, node) in self.children.enumerated() {
            if node.name == "ball" {
                
                if let cBall = getCountryball(node: node) {
                    
                    if let ballNode = cBall.ballNode {
                        if ballNode.position.y + cBall.ballSize/2 < max.position.y - 2.5 {
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
        
        if let ballNode  = cb?.ballNode  {
            if object?.name == "ball" && ballNode.name == "ball" {
                if let cb2 = getCountryball(node: object!) {
                    
                    if (cb!.ballName == cb2.ballName && cb2.ballName != "world") {
                        if let node1 = cb!.ballNode {
                            if let node2 = cb2.ballNode {
                                let newX = (node1.position.x + node2.position.x)/2.0
                                let newY = (node1.position.y + node2.position.y)/2.0
                                
                                
                                destroyBall(ball: cb!)
                                destroyBall(ball: cb2)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    [unowned self] in
                                    
                                    combineCB(cb1: cb!, cb2: cb2, at: CGPoint(x: newX, y: newY))
                                }
                            }
                        }
                        
                        //MARK: Play sound effect
                        if playSoundEffects {
                            soundEffects.run(SKAction.play())
                        }
                        
                        
                        if showNames && !cb2.nameShown {
                            showName(cb: cb2)
                            cb2.nameShown = true
                        }
                        
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
                newBall.ballNode!.physicsBody!.isDynamic = true
                addChild(newBall.ballNode!)
                balls.append(newBall)
                newBall.ballNode!.name = "ball"
                
                let velocity = CGVector(dx: newBall.ballNode!.physicsBody!.mass * 1.5 * CGFloat(leftOrRight()), dy: newBall.ballNode!.physicsBody!.mass * 1.5)
                newBall.ballNode!.run(SKAction.applyForce(velocity, duration: 1))
                
                if showNames && !newBall.nameShown {
                    showName(cb: newBall)
                    newBall.nameShown = true
                }
                
                if playSoundEffects && !newBall.hapticsActivated {
                    feedbackGen.notificationOccurred(.success)
                    newBall.hapticsActivated = true
                }
                
                //MARK: Emitter node
                if let fireParticles = SKEmitterNode(fileNamed: "Spark") {
                    fireParticles.position = newBall.ballNode!.position
                    fireParticles.name = "fireParticles"
                    addChild(fireParticles)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        [unowned self] in
                        fireParticles.removeFromParent()
                    }
                }
                
                newBall.dropped = true
                
                let scene = SKScene(fileNamed: "EndScene")! as! EndScene
                
                if let ballNode = newBall.ballNode {
                    if newCBName == "world" && (ballNode.position.y + newBall.ballSize/2 < max.position.y - 2.5){
                        scene.win = true
                        scene.muted = muted
                        scene.showNames = showNames
                        scene.playSoundEffects = playSoundEffects
                        let transition = SKTransition.crossFade(withDuration: 1)
                        self.view?.presentScene(scene, transition: transition)
                    } else if ballNode.position.y + newBall.ballSize/2 >= max.position.y - 2.5 {
                        scene.win = false
                        scene.muted = muted
                        scene.showNames = showNames
                        scene.playSoundEffects = playSoundEffects
                        let transition = SKTransition.crossFade(withDuration: 1)
                        self.view?.presentScene(scene, transition: transition)
                    }
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
        
        var name: SKLabelNode? = SKLabelNode(fontNamed: "American Typewriter")
        name!.text = cbName
        
        if let ballNode = cb.ballNode {
            if ballNode.position.x < name!.frame.size.width/2 {
                name!.position = CGPoint(x: name!.frame.size.width/2, y: ballNode.position.y + cb.ballSize*1.05)
            } else if ballNode.position.x > self.size.width - name!.frame.size.width/2 {
                name!.position = CGPoint(x: self.size.width - name!.frame.size.width/2, y: ballNode.position.y + cb.ballSize*1.05)
            } else {
                name!.position = CGPoint(x: ballNode.position.x, y: ballNode.position.y + cb.ballSize*1.05)
            }
        }
        name!.zPosition = 5
        addChild(name!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            [unowned self] in
            name!.removeFromParent()
            name = nil
        }
    }
    
    func destroyBall(ball: Countryball) {
        //Remove countryballs from array
        for (index, ball1) in balls.enumerated() {
            if let ballNode = ball.ballNode {
                if let ballNode1 = ball1.ballNode {
                    if ballNode.position == ballNode1.position {
                        balls.remove(at: index)
                    }
                }
            }
        }
        
        if let ballNode = ball.ballNode {
            ballNode.removeFromParent()
            
            // Remove actions
            ballNode.removeAllActions()
            
            // Disable physics
            ballNode.physicsBody?.isDynamic = false
            ballNode.physicsBody = nil
            
            // Release textures
            ballNode.texture = nil
        }
        
    }
    
    func spawnTopCB(at position: CGPoint) {
        let ball = Countryball()
        ball.spawn(at: position, named: ball.newCbName())
        ball.ballNode!.name = "ready"
        addChild(ball.ballNode!)
        balls.append(ball)
    }
    
    func dropCB(node: SKNode) {
        
        node.physicsBody!.isDynamic = true
        node.physicsBody!.restitution = 0.005
        node.name = "ball"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            [unowned self] in
            self.spawnTopCB(at: CGPoint(x: self.size.width/2, y: self.size.height * spawnHeight))
            
        }
        return
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
            if let ballNode = ball.ballNode {
                if node.position == ballNode.position {
                    return ball
                }
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
            backgroundMusic.removeFromParent()
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

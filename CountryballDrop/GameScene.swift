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
 TODO: Red line, touching red line = loses, red line @0.85 height
 TODO: Red line appears when you reach certain point @0.75 height
 TODO: Music
 TODO: Intro & Outro Scene With Graphics
 TODO: If you have a world, you win
 TODO: Timer
 TODO: Emitter cell when combine
 
I actually made a game though
 */

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    
    var balls = [Countryball]()
    var spawnHeight = 0.87
    var maxHeight = 0.8
    var warningHeight = 0.6
    let names = ["vatican", "luxembourg", "netherlands", "ireland", "uk",
                 "poland", "germany", "ukraine", "russia", "world"]
    var inMenu = false
    var backgroundMusic: SKAudioNode!
    var muteButton: SKSpriteNode!
    var muted = false
    var max: SKNode!
    var warning: SKNode!
    //To lose: if the ball's y + ball.height/2 >= max height
    //Warning: if the ball's y + ball.height/2 >= warning height
    
    override func didMove(to view: SKView) {
        //        maxHeight = self.size.height * 0.8
        //        warningHeight = self.size.height * 0.6
        //        spawnHeight = self.size.height * 0.87
        //self.wid
        
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
       // warning.physicsBody = SKPhysicsBody(rectangleOf: warningSize)
       // warning.physicsBody!.isDynamic = false
        warning.isHidden = true
        warning.name = "warning"
        addChild(warning)
        
        //let warningSize = CGSize(width: self.size.width, height: 5)
        max = SKSpriteNode(color: UIColor(red: 0, green: 1, blue: 0, alpha: 1), size: warningSize)
        max.zPosition = -1
        max.position = CGPoint(x: self.size.width/2, y: self.size.height * maxHeight)
        //max.physicsBody = SKPhysicsBody(rectangleOf: warningSize)
       // max.physicsBody!.isDynamic = false
        max.isHidden = false
        max.name = "max"
        addChild(max)
        
        spawnTopCB(at: CGPoint(x: self.size.width/2, y: self.size.height * spawnHeight))
        //generateBall()
        
        muteButton = SKSpriteNode(imageNamed: "unMuteMusic")
        muteButton.position = CGPoint(x: 50, y: 50)
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
        //drop ball, change name
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)
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
            
            for node in children {
                if node.name == "ready" {
                    //print("ball ready")
                    let cb = node as! Countryball
                    
                    //ball.physicsBody!.isDynamic = false
                    cb.position = CGPoint(x: location.x, y: node.position.y)
                    cb.physicsBody!.isDynamic = true
                    //cb.dropped = true
                    cb.physicsBody!.restitution = 0.005
                    cb.name = "ball"
                    print(cb.name!)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        [unowned self] in
                        self.spawnTopCB(at: CGPoint(x: self.size.width/2, y: self.size.height * spawnHeight))
                    }
                    
                    //return
                    //print(node.)
                    //no
                }
            }
            
            /*for ball in balls {
             }
             }*/
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //TODO: Warning/max
        if contact.bodyA.node?.name == "ball" && (contact.bodyB.node?.name == "bottom" || contact.bodyB.node?.name == "ball") {
            let cb = contact.bodyA.node! as! Countryball
            cb.dropped = true
            print(cb.dropped)
            
            if contact.bodyB.node?.name == "ball" {
                let cb1 = contact.bodyB.node! as! Countryball
                cb1.dropped = true
                collisionBetween(cb: cb, object: contact.bodyB.node!)
            } else {
                let velocity = CGVector(dx: cb.physicsBody!.mass * 1.5 * CGFloat(leftOrRight()), dy: cb.physicsBody!.mass * 1.5)
                cb.run(SKAction.applyForce(velocity, duration: 1))
            }
            //print
            //contact.bodyA.node?.name = "ball"
        } else if (contact.bodyA.node?.name == "bottom" || contact.bodyA.node?.name == "ball") && contact.bodyB.node?.name == "ball" {
            let cb = contact.bodyB.node! as! Countryball
            cb.dropped = true
            print(cb.dropped)
            
            if contact.bodyA.node?.name == "ball" {
                let cb1 = contact.bodyA.node! as! Countryball
                cb1.dropped = true
                collisionBetween(cb: cb, object: contact.bodyA.node!)
            } else {
                //TODO: Random left/right direction
                let velocity = CGVector(dx: cb.physicsBody!.mass * 1.5 * CGFloat(leftOrRight()), dy: cb.physicsBody!.mass * 1.5)
                cb.run(SKAction.applyForce(velocity, duration: 1))
            }
            //contact.bodyB.node?.name = "ball"
        }
        
    }
    
    func collisionBetween(cb: Countryball?, object: SKNode?) {
        //print(object?.name)
        if object?.name == "ball" && cb?.name == "ball" {
            print("inside here")
            let cb2 = object as! Countryball
            
            if (cb!.ballName == cb2.ballName && cb2.ballName != "world") {
                print("Balls combining: \(cb2.ballName)")
                let newX = (cb!.position.x + cb2.position.x)/2.0
                let newY = (cb!.position.y + cb2.position.y)/2.0
                
                /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    [unowned self] in
                    self.combineCB(cb1: cb!, cb2: cb2, at: CGPoint(x: newX, y: newY))
                }*/
                combineCB(cb1: cb!, cb2: cb2, at: CGPoint(x: newX, y: newY))
            }
        }
    }
    
    func combineCB(cb1: Countryball, cb2: Countryball, at position: CGPoint) {
        print("inside")
        var newCBName = ""
        
        for (index, name) in names.enumerated() {
            if name == cb1.ballName && name == cb2.ballName {
                //print("Result: \(name)")
                newCBName = names[index + 1]
                //let v1 = cb1.physicsBody?.
                //let v2 = cb2.physicsBody?.velocity
                //TODO: Random left/right direction
                
                
                
                destroyBall(ball: cb1)
                destroyBall(ball: cb2)
                
                let newBall = Countryball()
                newBall.spawn(at: position, named: newCBName)
                newBall.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(newBall.ballSize)/2.0)
                newBall.physicsBody!.isDynamic = true
                newBall.physicsBody!.contactTestBitMask = newBall.physicsBody!.collisionBitMask
                addChild(newBall)
                newBall.name = "ball"
                let velocity = CGVector(dx: newBall.physicsBody!.mass * 1.5 * CGFloat(leftOrRight()), dy: newBall.physicsBody!.mass * 1.5)
                newBall.run(SKAction.applyForce(velocity, duration: 1))
                
                newBall.dropped = true
                
                if newCBName == "world" {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        [unowned self] in
                        //TODO: New Scene
                        let scene = SKScene(fileNamed: "EndScene")! as! EndScene
                        scene.win = true
                        
                        let transition = SKTransition.crossFade(withDuration: 1)
                        self.view?.presentScene(scene, transition: transition)
                    }
                }
                
                print("Result: \(newCBName)")
                break
            }
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
}



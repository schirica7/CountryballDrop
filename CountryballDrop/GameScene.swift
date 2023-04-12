//
//  GameScene.swift
//  CountryballDrop
//
//  Created by Stefan Chirica on 3/14/23.
//

import SpriteKit
import GameplayKit

/*TODO: Collisions
 TODO: Menu button - music, restart, exit
 TODO: Animations?
 TODO: Red line, touching red line = loses, red line @0.85 height
 TODO: Red line appears when you reach certain point @0.75 height
 TODO: Music
 TODO: Intro & Outro Scene With Graphics
 TODO: If you have a world, you win
 TODO: Timer
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
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //drop ball, change name
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            for node in children {
                if node.name == "ready" {
                    //print("ball ready")
                    let cb = node as! Countryball
                    
                    //ball.physicsBody!.isDynamic = false
                    cb.position = CGPoint(x: location.x, y: node.position.y)
                    cb.physicsBody!.isDynamic = true
                    //cb.dropped = true
                    cb.physicsBody!.restitution = 0.01
                    cb.name = "ball"
                    print(cb.name!)
                    spawnTopCB(at: CGPoint(x: self.size.width/2, y: self.size.height * spawnHeight))
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
            }
            //contact.bodyB.node?.name = "ball"
        }
        
    }
    
    func collisionBetween(cb: Countryball?, object: SKNode?) {
        //print(object?.name)
        if object?.name == "ball" && cb?.name == "ball" {
            print("inside here")
            let cb2 = object as! Countryball
            
            if (cb!.ballName == cb2.ballName) {
                print("Balls combining: \(cb2.ballName)")
                let newX = (cb!.position.x + cb2.position.x)/2.0
                let newY = (cb!.position.y + cb2.position.y)/2.0
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
                
                destroyBall(ball: cb1)
                destroyBall(ball: cb2)
                
                let newBall = Countryball()
                newBall.spawn(at: position, named: newCBName)
                newBall.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(newBall.ballSize)/2.0)
                newBall.physicsBody!.isDynamic = true
                newBall.physicsBody!.contactTestBitMask = newBall.physicsBody!.collisionBitMask
                addChild(newBall)
                newBall.name = "ball"
                newBall.dropped = true
                
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
        //balls.append(ball)
        //print(ball.ballSize)
        //print(ball.physicsBody?.isDynamic)
        //ball.ballNode.texture().
    }
    
    
    func spawnMenu() {
        
    }
    
}



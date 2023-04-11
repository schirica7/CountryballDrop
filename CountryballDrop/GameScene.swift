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
        warning.isHidden = true
        warning.name = "warning"
        addChild(warning)
        
        //let warningSize = CGSize(width: self.size.width, height: 5)
        max = SKSpriteNode(color: UIColor(red: 0, green: 1, blue: 0, alpha: 1), size: warningSize)
        max.zPosition = -1
        max.position = CGPoint(x: self.size.width/2, y: self.size.height * maxHeight)
        max.isHidden = true
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
                    print("ball ready")
                    let cb = node as! Countryball
                    
                    //ball.physicsBody!.isDynamic = false
                    cb.position = CGPoint(x: location.x, y: node.position.y)
                    cb.physicsBody!.isDynamic = true
                    //cb.dropped = true
                    cb.physicsBody!.restitution = 0.01
                    cb.name = "ball"
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
        /*if (contact.bodyA.node?.name == "ball") {
         collisionBetween(ball: contact.bodyA.node, object: contact.bodyB.node)
         } else if (contact.bodyB.node?.name == "ball") {
         collisionBetween(ball: contact.bodyB.node, object: contact.bodyA.node)
         }*/
        
        if contact.bodyA.node?.name == "ready" && (contact.bodyB.node?.name == "max") {
            let cb = contact.bodyA.node as! Countryball
            cb.dropped = true
            contact.bodyA.node?.name = "ball"
        } else if contact.bodyA.node?.name == "max" && (contact.bodyB.node?.name == "ready") {
            let cb = contact.bodyB.node as! Countryball
            cb.dropped = true
            contact.bodyB.node?.name = "ball"
        }
        
        
        if contact.bodyA.node?.name == "ball" && (contact.bodyB.node?.name == "max" || contact.bodyB.node?.name == "warning") {
            collisionBetween(cb: (contact.bodyA.node as! Countryball), object: contact.bodyB.node)
        } else if (contact.bodyA.node?.name == "max" || contact.bodyA.node?.name == "warning") && contact.bodyB.node?.name == "ball" {
            //contact.bodyB.node!.
            collisionBetween(cb: (contact.bodyB.node as! Countryball), object: contact.bodyA.node)
        }
        
    }
    
    func collisionBetween(cb: Countryball?, object: SKNode?) {
        print(object?.name)
    }
    
    func collisionBetween(cb1: Countryball?, cb2: Countryball?) {
        
        /*if (cb1?.name == cb2?.name) && (cb1?.name != "ball" && cb2?.name != "ball"){
         //combineCB(at: <#T##CGPoint#>)
         } else {*/
        if cb1?.ballName == cb2?.ballName {
            cb1!.name = cb1!.ballName
            print(cb1!.name!)
        }
        //}
        /*if object?.name == "good" {
         //get point
         //destroy ball
         destroyBall(ball: ball, good: true)
         score += 1
         ballLimit += 1
         } else if object?.name == "bad" {
         destroyBall(ball: ball, good: false)
         if ballLimit > 0 {
         score -= 1
         ballLimit -= 1
         }
         
         
         //lose point?
         } else if object?.name == "box" {
         object!.removeFromParent()
         }*/
    }
    
    func destroyBall(ball: SKNode?) {
        /*if good {
         if let fireParticles = SKEmitterNode(fileNamed: "Fireflies") {
         if ball != nil {
         fireParticles.position = ball!.position
         fireParticles.name = "fireParticles"
         addChild(fireParticles)
         }
         }
         } else {
         if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
         if ball != nil {
         fireParticles.position = ball!.position
         fireParticles.name = "fireParticles"
         addChild(fireParticles)
         }
         }
         }*/
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
        balls.append(ball)
        //print(ball.ballSize)
        //print(ball.physicsBody?.isDynamic)
        //ball.ballNode.texture().
    }
    
    func combineCB(at position: CGPoint) {
        
    }
    
    func spawnMenu() {
        
    }
    
}



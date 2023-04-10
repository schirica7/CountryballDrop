//
//  GameScene.swift
//  CountryballDrop
//
//  Created by Stefan Chirica on 3/14/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    var maxHeight = 0.0
    var warningHeight = 0.0
    
    let names = ["vatican", "luxembourg", "netherlands", "ireland", "uk",
        "poland", "germany", "ukraine", "russia", "world"]
    
    //To lose: if the ball's y + ball.height/2 >= max height
    //Warning: if the ball's y + ball.height/2 >= warning height
    
    override func didMove(to view: SKView) {
        maxHeight = self.size.height * 0.8
        warningHeight = self.size.height * 0.7
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        
        let rectSize = CGSize(width: self.size.width, height: self.size.height * 0.11)
        let bottom = SKSpriteNode(color: UIColor(red: 255/255, green: 210/255, blue: 79/255, alpha: 1), size: rectSize)
        bottom.physicsBody = SKPhysicsBody(rectangleOf: rectSize)
        bottom.physicsBody!.isDynamic = false
        //bottom.physicsBody!.contactTestBitMask = bottom.physicsBody!.collisionBitMask
        bottom.zPosition = -1
        bottom.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.055)
        addChild(bottom)
        
        spawnTopCB(at: CGPoint(x: self.size.width/2, y: self.size.height * 0.8))
        //generateBall()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       //drop ball, change name
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            for node in children {
                if node.name == "ready" {
                    print("ball ready")
                    
                    //ball.physicsBody!.isDynamic = false
                    node.position = CGPoint(x: location.x, y: node.position.y)
                    node.physicsBody!.isDynamic = true
                    node.physicsBody!.restitution = 0.01
                    node.name = "ball"
                    spawnTopCB(at: CGPoint(x: self.size.width/2, y: self.size.height * 0.9))
                    //print(node.)
                    //no
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "ball") {
            collisionBetween(ball: contact.bodyA.node, object: contact.bodyB.node)
        } else if (contact.bodyB.node?.name == "ball") {
            collisionBetween(ball: contact.bodyB.node, object: contact.bodyA.node)
        }
        
        
    }
    
    func collisionBetween(ball: SKNode?, object: SKNode?) {
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
    
    func destroyBall(ball: SKNode?, good: Bool) {
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
        ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(ball.ballSize/2))
        ball.physicsBody!.isDynamic = false
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        addChild(ball)
        ball.name = "ready"
        print(ball.ballSize)
        //print(ball.physicsBody?.isDynamic)
        //ball.ballNode.texture().
    }
    
    func combineCB(at position: CGPoint) {
        
    }
    
}

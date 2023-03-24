//
//  GameScene.swift
//  CountryballDrop
//
//  Created by Stefan Chirica on 3/14/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
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
        
        backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        
        let rectSize = CGSize(width: self.size.width, height: self.size.height * 0.11)
        let bottom = SKSpriteNode(color: UIColor(red: 255/255, green: 210/255, blue: 79/255, alpha: 1), size: rectSize)
        bottom.physicsBody = SKPhysicsBody(rectangleOf: rectSize)
        bottom.physicsBody!.isDynamic = false
        bottom.zPosition = 4
        bottom.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.055)
        addChild(bottom)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       //drop ball, change name
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
        if good {
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
        }
        ball?.removeFromParent()
    }
    
    func spawnCB() {
        let ball = Countryball()
        ball.spawn()
        addChild(ball)
        //ball.
    }
    
}

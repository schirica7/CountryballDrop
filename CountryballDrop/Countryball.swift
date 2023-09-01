//
//  Countryball.swift
//  CountryballDrop
//
//  Created by Stefan Chirica on 3/24/23.
//

import UIKit
import SpriteKit


//TODO: Lay framework for non-European countryballs

class Countryball {
    var ballNode: SKSpriteNode? = SKSpriteNode()
    var dropped = false {
        didSet {
            print("\(ballName) Dropped: \(dropped)")
        }
    }
    
    var status = ""
    var ballName = ""
    var ballSize: CGFloat = 0.0
    var nameShown = false
    
    
    let names = ["vatican", "luxembourg", "netherlands", "ireland", "uk",
        "poland", "germany", "ukraine", "russia", "world"]
    
    func spawn(at position: CGPoint, named name: String) {
        ballNode = SKSpriteNode(imageNamed: name)
        ballNode!.position = position
        ballSize = ballNode!.size.width
        ballNode!.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(ballSize)/2.0)
        ballNode!.physicsBody!.isDynamic = false
        ballNode!.physicsBody!.contactTestBitMask = ballNode!.physicsBody!.collisionBitMask
        ballName = name
        
        //addChild(ballNode)
    }
    
    deinit {
        print("Countryball deallocated")
    }
    
    func newCbName() -> String {
        let number = Double.random(in: 0...1)
        var name = ""
        
        if number > 0.9 {
            name = "ireland"
        } else if number > 0.7 {
            name = "netherlands"
        } else if number > 0.4 {
            name = "luxembourg"
        } else {
            name = "vatican"
        }
        
        ballName = name
        return name
    }
    
}

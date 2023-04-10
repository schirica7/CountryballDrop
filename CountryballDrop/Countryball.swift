//
//  Countryball.swift
//  CountryballDrop
//
//  Created by Sneezy on 3/24/23.
//

import UIKit
import SpriteKit

class Countryball: SKSpriteNode {
    var ballNode: SKSpriteNode!
    var dropped = false
    var ballName = ""
    var ballSize = 0
    
    let names = ["vatican", "luxembourg", "netherlands", "ireland", "uk",
        "poland", "germany", "ukraine", "russia", "world"]
    
    func spawn(at position: CGPoint, named name: String) {
        self.position = position
        //var name = cbName()
        
        ballNode = SKSpriteNode(imageNamed: name)
        //ballNode.position = CGPoint(x: 0, y: -50)
        setCbSize(name: name)
        
        addChild(ballNode)
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
    
    func setCbSize(name: String) {
        switch ballName {
            
        case "vatican":
            ballSize = 40
        case "luxembourg":
            ballSize = 80
        case "netherlands":
            ballSize = 120
        case "ireland":
            ballSize = 160
        case "uk":
            ballSize = 200
        case "poland":
            ballSize = 240
        case "germany":
            ballSize = 280
        case "ukraine":
            ballSize = 320
        case "russia":
            ballSize = 360
        case "world":
            ballSize = 400
        default:
            break
            
        }
    }
}

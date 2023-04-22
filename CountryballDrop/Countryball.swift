//
//  Countryball.swift
//  CountryballDrop
//
//  Created by Stefan Chirica on 3/24/23.
//

import UIKit
import SpriteKit

class Countryball: SKSpriteNode {
    var ballNode: SKSpriteNode!
    var dropped = false {
        didSet {
            print("\(ballName) Dropped: \(dropped)")
        }
    }
    var ballName = ""
    var ballSize: CGFloat = 0.0
    var nameShown = false
    
    
    let names = ["vatican", "luxembourg", "netherlands", "ireland", "uk",
        "poland", "germany", "ukraine", "russia", "world"]
    
    func spawn(at position: CGPoint, named name: String) {
        self.position = position
        //var name = cbName()
        
        ballNode = SKSpriteNode(imageNamed: name)
        ballSize = ballNode.size.width
        ballName = name
        
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
}

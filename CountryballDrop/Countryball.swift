//
//  Countryball.swift
//  CountryballDrop
//
//  Created by Sneezy on 3/24/23.
//

import UIKit
import SpriteKit

class Countryball: SKSpriteNode {

    func spawn() {
        
    }
    
    func cbName() -> String {
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
        
        return name
    }
}

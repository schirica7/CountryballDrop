//
//  LogoScene.swift
//  CountryballDrop
//
//  Created by Stefan Chirica on 4/26/23.
//

import UIKit
import SpriteKit
import GameplayKit

class LogoScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        
        let logo = SKSpriteNode(imageNamed: "baskingbrain")
        logo.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        addChild(logo)
        
        
    }
}

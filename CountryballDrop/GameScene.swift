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
    
    //To lose: if the ball's y + ball.height/2 >= max height
    //Warning: if the ball's y + ball.height/2 >= warning height
    
    override func didMove(to view: SKView) {
        maxHeight = self.size.height * 0.9
        warningHeight = self.size.height * 0.7
        
        backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        
        let bottom = SKSpriteNode(color: UIColor(red: 255/255, green: 210/255, blue: 79/255, alpha: 1), size: CGSize(width: self.size.width, height: self.size.height * 0.11))
        bottom.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.055)
        addChild(bottom)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
}

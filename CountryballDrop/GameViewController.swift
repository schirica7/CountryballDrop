//
//  GameViewController.swift
//  CountryballDrop
//
//  Created by Stefan Chirica on 3/14/23.
//

import GoogleMobileAds
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    let banner: GADBannerView = {
        let bannerView = GADBannerView()
        bannerView.adUnitID = "ca-app-pub-6080953864782497/4087148077"
        return bannerView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(banner)
        banner.backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        banner.rootViewController = self
        banner.load(GADRequest())
        banner.isHidden = true
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "LogoScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: view.frame.size.width * 0.1, y: view.frame.size.height * 0.9175, width: view.frame.size.width * 0.8, height: view.frame.size.height * 0.055)
    }
}

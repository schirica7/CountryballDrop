//
//  GameViewController.swift
//  CountryballDrop
//
//  Created by Sneezy on 3/14/23.
//

import GoogleMobileAds
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    private let banner: GADBannerView = {
        let bannerView = GADBannerView()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //bannerView.adUnitID = "ca-app-pub-6080953864782497/4087148077"
        return bannerView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        banner.backgroundColor = .systemGray
        view.addSubview(banner)
        banner.rootViewController = self
        banner.load(GADRequest())
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "WelcomeScene") {
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

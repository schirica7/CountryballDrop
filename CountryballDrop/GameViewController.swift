//
//  GameViewController.swift
//  CountryballDrop
//
//  Created by Stefan Chirica on 3/14/23.
//

import GoogleMobileAds
import UserMessagingPlatform
import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    var isMobileAdsStartCalled = false;
    
    let banner: GADBannerView = {
        let banner = GADBannerView()
        
        //Test ads
        //banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        //Real ads
        banner.adUnitID = "ca-app-pub-6080953864782497/4087148077"
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is now the latest version")
        //Ad banner
        banner.backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        banner.rootViewController = self
        view.addSubview(banner)
        banner.isHidden = true
        
        // Request an update for the consent information.
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: nil) {
            [weak self] requestConsentError in
            guard let self else { return }
            
            if let consentError = requestConsentError {
                // Consent gathering failed.
                return print("Error: \(consentError.localizedDescription)")
            }
            
            UMPConsentForm.loadAndPresentIfRequired(from: self) {
                [weak self] loadAndPresentError in
                guard let self else { return }
                
                if let consentError = loadAndPresentError {
                    // Consent gathering failed.
                    return print("Error: \(consentError.localizedDescription)")
                }
                
                // Consent has been gathered.
                if UMPConsentInformation.sharedInstance.canRequestAds {
                          self.startGoogleMobileAdsSDK()
                }
            }
        }
        
        // Check if you can initialize the Google Mobile Ads SDK in parallel
            // while checking for new consent information. Consent obtained in
            // the previous session can be used to request ads.
            if UMPConsentInformation.sharedInstance.canRequestAds {
              startGoogleMobileAdsSDK()
            }
        
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
    
    private func startGoogleMobileAdsSDK() {
        //DispatchQueue.main.async {
          guard !self.isMobileAdsStartCalled else { return }

          self.isMobileAdsStartCalled = true

          // Initialize the Google Mobile Ads SDK.
          GADMobileAds.sharedInstance().start()

          // TODO: Request an ad.
            self.banner.load(GADRequest())
        //}
      }
}

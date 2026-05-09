//
//  PrizeCarouselScene.swift
//  CountryballDrop
//

import SpriteKit
import UIKit

class PrizeCarouselScene: SKScene {

    var muted = false
    var showNames = false
    var playSoundEffects = false

    private let pool = UnlockedCountryballsStore.europeanIds
    private weak var carouselSprite: SKSpriteNode?
    private var subtitleLabel = SKLabelNode(fontNamed: "American Typewriter")
    private let feedbackGen = UINotificationFeedbackGenerator()

    private var backgroundMusic = SKAudioNode()

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)

        subtitleLabel.fontSize = 22
        subtitleLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.82)
        subtitleLabel.verticalAlignmentMode = .center
        subtitleLabel.horizontalAlignmentMode = .center
        subtitleLabel.text = "Spinning prize…"
        addChild(subtitleLabel)

        let frame = SKShapeNode(rectOf: CGSize(width: size.width * 0.52, height: size.width * 0.52), cornerRadius: 12)
        frame.strokeColor = .white
        frame.lineWidth = 4
        frame.fillColor = .clear
        frame.position = CGPoint(x: size.width * 0.5, y: size.height * 0.52)
        frame.zPosition = 1
        addChild(frame)

        let slot = SKSpriteNode(imageNamed: pool[0])
        slot.size = CGSize(width: size.width * 0.45, height: size.width * 0.45)
        slot.position = frame.position
        slot.zPosition = 0
        addChild(slot)
        carouselSprite = slot

        if let vc = view.window?.rootViewController as? GameViewController {
            vc.banner.backgroundColor = backgroundColor
            vc.banner.isAutoloadEnabled = true
            vc.banner.isHidden = true
        }

        if let musicLocation = Bundle.main.url(forResource: "menu sound", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicLocation)
            backgroundMusic.autoplayLooped = true
            addChild(backgroundMusic)
            backgroundMusic.run(SKAction.changeVolume(to: muted ? 0 : 0.42, duration: 0))
            backgroundMusic.run(SKAction.play())
        }

        let prize = pool.randomElement()!
        feedbackGen.prepare()

        run(buildCarouselSpin(prize: prize, slot: slot), completion: {
            UnlockedCountryballsStore.unlock(prize)
            let title = UnlockedCountryballsStore.displayTitle(for: prize)
            self.subtitleLabel.text = "You won: \(title)!"
            if self.playSoundEffects {
                self.feedbackGen.notificationOccurred(.success)
            }
            self.run(SKAction.wait(forDuration: 1.45)) {
                let end = SKScene(fileNamed: "EndScene") as! EndScene
                end.win = true
                end.muted = self.muted
                end.showNames = self.showNames
                end.playSoundEffects = self.playSoundEffects
                let transition = SKTransition.fade(withDuration: 0.8)
                self.view?.presentScene(end, transition: transition)
            }
        })
    }

    /// ~4 seconds of accelerating slot ticks, then settles on `prize`.
    private func buildCarouselSpin(prize: String, slot: SKSpriteNode) -> SKAction {
        let total: TimeInterval = 4
        let count = 56
        var weights: [Double] = []
        for i in 0..<count {
            let p = Double(i) / Double(max(count - 1, 1))
            weights.append(0.022 + pow(p, 1.95) * 0.42)
        }
        let scale = total / weights.reduce(0, +)

        var actions: [SKAction] = []
        for i in 0..<count {
            let name = i >= count - 12 ? prize : pool.randomElement()!
            let w = weights[i] * scale
            actions.append(SKAction.run { [weak self, weak slot] in
                slot?.texture = SKTexture(imageNamed: name)
                if self?.playSoundEffects == true, i % 4 == 0 {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            })
            actions.append(SKAction.wait(forDuration: w))
        }
        return SKAction.sequence(actions)
    }
}

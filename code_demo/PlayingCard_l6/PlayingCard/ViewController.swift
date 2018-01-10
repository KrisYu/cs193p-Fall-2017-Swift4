//
//  ViewController.swift
//  PlayingCard
//
//  Created by XueYu on 1/9/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()
    
    
    @IBOutlet weak var playingCardView: PlayingCardView! {
        didSet {
            // add swipe gesture
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            playingCardView.addGestureRecognizer(swipe)
            // add pinch gesture, and this handler in the view
            
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adbjustFaceCardScale(byHandlingGestureRecognizedBy:)))
            playingCardView.addGestureRecognizer(pinch)
            
        }
    }
    
    // this function is added drop the Tap Gesture Recognizer to the playingCardView
    // and we can configure it in the IB
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        // switch on the state
        switch sender.state {
        case .ended:
            playingCardView.isFaceUp = !playingCardView.isFaceUp
        default:
            break
        }
    }
    
    
    // because the target-action mechanism is built on ObjC, so we need to explose this function
    @objc func nextCard() {
        if let card = deck.draw() {
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)")
            }
        }
    }
    
}

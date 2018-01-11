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
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    // step 1 : animator
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count + 1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView)
        }
    }
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter{ $0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1 }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 && faceUpCardViews[0].rank == faceUpCardViews[1].rank && faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    private var lastChoosenCardView: PlayingCardView?
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            // UITapGestureRecognizer knows which view it is tapping
            if let choosenCardView = recognizer.view as? PlayingCardView , faceUpCardViews.count < 2 {
                lastChoosenCardView = choosenCardView
                cardBehavior.removeItem(choosenCardView)
                UIView.transition(with: choosenCardView,
                                  duration: 0.6,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    choosenCardView.isFaceUp = !choosenCardView.isFaceUp
                },completion: { finished in
                    let cardsToAnimate = self.faceUpCardViews
                    if self.faceUpCardViewsMatch {
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75,
                                                                       delay: 0,
                                                                       options: [],
                                                                       animations: {
                                                                        cardsToAnimate.forEach {
                                                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)}
                                                                        
                        },completion: { postion in
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75,
                                                                           delay: 0,
                                                                           options: [],
                                                                           animations: {
                                                                            cardsToAnimate.forEach {
                                                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                                                
                                                                                $0.alpha = 0}
                            },completion: { postion in
                                cardsToAnimate.forEach{
                                    $0.isHidden = true
                                    $0.alpha = 1.0
                                    $0.transform = .identity
                                }
                            })
                        })
                    } else if cardsToAnimate.count == 2 {
                        if choosenCardView == self.lastChoosenCardView {
                            self.faceUpCardViews.forEach{ cardView in
                                UIView.transition(with: cardView,
                                                  duration: 0.6,
                                                  options: [.transitionFlipFromLeft],
                                                  animations: {
                                                    cardView.isFaceUp = false
                                }, completion: { finished in
                                    self.cardBehavior.addItem(cardView)
                                })
                            }
                        }
                    } else {
                        if !choosenCardView.isFaceUp {
                            self.cardBehavior.addItem(choosenCardView)
                        }
                    }
                })
            }
        default:
            break
        }
        
    }
    
    
    
}

extension CGFloat {
    var arc4random:  CGFloat {
        return CGFloat(arc4random_uniform(UInt32.max)) / CGFloat(UInt32.max) * self
    }
}

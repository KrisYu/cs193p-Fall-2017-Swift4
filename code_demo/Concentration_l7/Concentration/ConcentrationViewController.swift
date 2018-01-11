//
//  ViewController.swift
//  Concentration
//
//  Created by Xue Yu on 1/8/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1)/2
    }
    
    private(set) var flipCount = 0 {
        didSet{
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes : [NSAttributedStringKey : Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString.init(string: "Flips \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        
        if let cardNumber = cardButtons.index(of: sender) {
            game.chosenCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        // because we try to set theme before the outlet is created
        // and we call updateViewFromModel in theme didSet
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: .normal)
                    button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                } else {
                    button.setTitle("", for: .normal)
                    // if card is matched, then we will have the card background color be black, like it is hidden from the UI
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                }
            }
        }
        
    }
    
    var theme: String? {
        didSet{
            emojiChoices = theme ?? ""
            // reset it since theme changes, we'll change the emoji
            emoji = [:]
            updateViewFromModel()
        }
    }
    private var emojiChoices = "🦃😱🙀😈🍭🍬👻🎃"
    
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil {
            if emojiChoices.count > 0 {
                // String cannot index by Int, we have to use String.Index
                let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
                // remove(at: ) we get Character, we use this String init
                emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
            }
        }
        return emoji[card] ?? "?"
    }
    
}

// make meaningful extension, as Type Utility
extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}


//
//  ViewController.swift
//  Concentration
//
//  Created by Xue Yu on 1/8/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)

    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1)/2
    }
    
    // init will not call didSet, so we put the update in a seperate func
    // and we will call it both when flipCountLabel is
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
    
    // this connection is made by iOS, and when it is make the connection
    // it will set the flipCountLabel, so we can use didSet here
    // when the connections gets made, the didSet gets called
    // this should only be called once for this entire project that is when the connections gets made
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    

    @IBOutlet private var cardButtons: [UIButton]!
    
    // now emojiChoices is String
    private var emojiChoices = "🦃😱🙀😈🍭🍬👻🎃"
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        
        if let cardNumber = cardButtons.index(of: sender) {
            game.chosenCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    // definately private, don't want others to touch this
    private func updateViewFromModel() {
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


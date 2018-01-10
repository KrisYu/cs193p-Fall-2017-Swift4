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
    // this is the model, often it is public
    // here we make it private because numberOfPairsOfCards is tied to UI and we don't want to make it public
    
    
    // becasue it's already a get-only, so it is safe people don't overwrite it
    // we make it default-internal so that people can know how many numberOfPairsOfCards there is
    // computed properties
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1)/2
    }
    
    // we don't want people set it
    private(set) var flipCount = 0 {
        didSet{
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    // Outlets and Actions related to UI, make them private most of the time
    @IBOutlet private weak var flipCountLabel: UILabel!
    

    @IBOutlet private var cardButtons: [UIButton]!
    
    // this needs to be changed for assignment
    // the strategy is to just mark everything private by default and then modify it
    private var emojiChoices = ["🦃","😱","🙀","😈","🍭","🍬", "👻","🎃" ]

    
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
    
    private var emoji = [Int:String]()
    
    private func emoji(for card: Card) -> String {
        // if the link, card.identifier to String hasn't been mapped, we'll set it now, this will make the card with same identifier has the same emoji on card
        if emoji[card.identifier] == nil {
            if emojiChoices.count > 0 {
                // this protects if we have no emojiChoices left, this will only happen if we have more cards pairs than emoji choices
                emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
            }
        }
        // if optional, have default value, swift syntax sugar
        return emoji[card.identifier] ?? "?"
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


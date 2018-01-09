//
//  ViewController.swift
//  Concentration
//
//  Created by Xue Yu on 1/8/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
    // if not lazy, we have problem since cardButtons havn't been inited, they're also in the init process
    // lazy will init game when we trying to use it
    
    
    
    
    var flipCount = 0 {
        didSet{
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    

    @IBOutlet var cardButtons: [UIButton]!
    
    var emojiChoices = ["🦃","😱","🙀","😈","🍭","🍬", "👻","🎃" ]

    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        
        if let cardNumber = cardButtons.index(of: sender) {
            game.chosenCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    func updateViewFromModel() {
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
    
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        // if the link, card.identifier to String hasn't been mapped, we'll set it now, this will make the card with same identifier has the same emoji on card
        if emoji[card.identifier] == nil {
            if emojiChoices.count > 0 {
                // this protects if we have no emojiChoices left, this will only happen if we have more cards pairs than emoji choices
                let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
                emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
            }
        }
        // if optional, have default value, swift syntax sugar
        return emoji[card.identifier] ?? "?"
    }
    

    
    
}


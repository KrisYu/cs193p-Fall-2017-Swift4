//
//  ViewController.swift
//  Concentration
//
//  Created by XueYu on 1/9/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!

    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chosenCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
        emojiChoices = emojiChoicesList[emojiChoicesList.count.arc4random]
        updateViewFromModel()
    }
    
    
    var emojiChoicesList = [["🙆","😂","😇","🤓","😻","😆","🎭","😽","🙆‍♂️","😎","🙋🏼"],
                            ["👨‍🌾","🌾","🐷","🐰","🚜","🐖","🐔","🐎","🐏","🐑","🐄"],
                            ["👻","🎃","🦇","🍬","🦃","👽","🙀","💀","😈","😱","🍭"],
                            ["👷","🚧","⛑","🏗","💪","📈","✂️","📍","👩‍🚀","📐","🗳"],
                            ["⛄️","❄️","🎿","🏂","🌨","⛷","🚡","⭐️","💙","🍜","🥘"],
                            ["🦁","🦂","🐆","🐇","🦊","🐽","🐷","🐳","🐙","🐻","🐔"]]
   
    lazy var emojiChoices = emojiChoicesList[emojiChoicesList.count.arc4random]
    

    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        
        // update flipCountLabel
        flipCountLabel.text = "Flips: \(game.flips)"
        scoreLabel.text = "Score: \(game.score)"

    }
    
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil {
            if emojiChoices.count > 0 {
                emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
            }
        }
        return emoji[card.identifier] ?? "?"
    }
    

    
}


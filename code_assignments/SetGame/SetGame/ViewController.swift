//
//  ViewController.swift
//  SetGame
//
//  Created by XueYu on 1/11/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame()
    
    @IBOutlet var cardButtons: [SetCardButton]!
    
    @IBOutlet weak var deckCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var hintButton: BorderButton!
    @IBOutlet weak var newButton: BorderButton!
    @IBOutlet weak var dealButton: BorderButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    
    @IBAction func touchCard(_ sender: SetCardButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    
    private func updateViewFromModel() {
        updateButtonsFromModel()
        updateHintButton()
        deckCountLabel.text = "Deck: \(game.deckCount )"
        scoreLabel.text = "Score: \(game.score) / \(game.numberSets)"
        
        dealButton.disable = (game.cardsOnTable.count) >= cardButtons.count || game.deckCount == 0
        dealButton.disable = game.hints.count == 0
    }
    
    private func updateHintButton(){
        hintButton.setTitle("\(game.hints.count) sets", for: .normal)
        _lastHint = 0
    }

    
    private func updateButtonsFromModel(){
        messageLabel.text = ""
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if index < game.cardsOnTable.count {
                //-------------------------------
                let card = game.cardsOnTable[index]
                button.setCard = card
                //--------------selected---------
                button.setBorderColor(color: game.cardsSelected.contains(card) ? Colors.matched : Colors.mismatched)
                //--------------TryMatched--------
                if let itIsSet = game.isSet {
                    if game.cardsTryMatched.contains(card) {
                        button.setBorderColor(color: itIsSet ? Colors.matched: Colors.mismatched)
                    }
                    messageLabel.text = itIsSet ? "A set" : "Not a Set"
                }
                //-------------------
            } else {
                button.setCard = nil
            }
        }
    }

    @IBAction func deal3(){
        if (game.cardsOnTable.count + 3) <= cardButtons.count {
            game.deal3()
            updateViewFromModel()
        }
    }
    
    private var timer: Timer?
    private var _lastHint = 0
    
    @IBAction func hint() {
        timer?.invalidate()
        if  game.hints.count > 0 {
            game.hints[_lastHint].forEach { (idx) in
                let button = self.cardButtons[idx]
                button.setBorderColor(color: Colors.hint)
            }
            messageLabel.text = "Set \(_lastHint + 1) Wait..."
            timer = Timer.scheduledTimer(withTimeInterval: 1.5,
                                         repeats: false) { [weak self] time in
                                            self?.game.hints[(self?._lastHint)!].forEach { (idx) in
                                                let button = self?.cardButtons[idx]
                                                button!.setBorderColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
                                            }
                                            self?._lastHint =
                                                (self?._lastHint)!.incrementCicle(in:(self?.game.hints.count)!)
                                            self?.messageLabel.text = ""
                                            self?.updateButtonsFromModel()
            }
        }
    }

 
    @IBAction func new(){
        game = SetGame()
        cardButtons.forEach{ $0.setCard = nil}
        updateViewFromModel()
    }
    


}


extension ViewController {
    //--------------Constants-----------
    
    private struct Colors {
        static let hint = #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)
        static let selected = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        static let matched = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        static let mismatched = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

}
extension Int {
    func incrementCicle (in number: Int)-> Int {
        return (number - 1) > self ? self + 1: 0
    }
}

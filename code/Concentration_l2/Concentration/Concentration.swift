//
//  Concentration.swift
//  Concentration
//
//  Created by Xue Yu on 1/8/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chosenCard(at index: Int) {
        // check only card is not matched
        if !cards[index].isMatched {
            // the newly chosen card is not the one chosen before
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                // since now we're anyway choosing two cards, we will set indexOfOneAndOnlyFaceUpCard to nil
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // here we have either indexOfOneAndOnlyFaceUpCard is nil, either 0 or 2 cards faceup
                // or matchIndex == index
                // either situation we would only want make indexOfOneAndOnlyFaceUpCard index
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            // card is a struct, so here add 2 different card with the same card identifier to the cards array
            cards += [card, card]
        }
    }
    
    // TODO: shuffle the cards
}

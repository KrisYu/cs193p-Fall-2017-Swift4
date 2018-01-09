//
//  Concentration.swift
//  Concentration
//
//  Created by Xue Yu on 1/8/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards = [Card]()
    // we don't want others set it
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        // computed property, the get will be called everytime we try to ask for it
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        // this means there's more than one card is faceup, so return nil
                        return nil
                    }
                }
            }
            return foundIndex
        }
        
        // this will be called everytime we set indexOfOneAndOnlyFaceUpCard
        set {
            for index in cards.indices {
                // evaluate the index, if it is the only one faceUp card
                // we'll make it faceUp, otherwise we make it face down
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chosenCard(at index: Int) {
        // protects the index out of boundaray error
        assert(cards.indices.contains(index), "Concentration.chosenCard(at: (\(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                // since now we're anyway choosing two cards, we will set indexOfOneAndOnlyFaceUpCard to nil
                cards[index].isFaceUp = true
                // indexOfOneAndOnlyFaceUpCard = nil
                // now we don't set it to nil manully because everytime we ask for this indexOfOneAndOnlyFaceUpCard, it will set the correct value

            } else {
                // here we have either indexOfOneAndOnlyFaceUpCard is nil, either 0 or 2 cards faceup
                // since whenever we set it we'll
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        // we can't make 0 or negative pair of cards
        assert(numberOfPairsOfCards > 0 ,"Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
    }
    
    // TODO: shuffle the cards
}

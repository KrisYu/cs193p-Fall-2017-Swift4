//
//  Concentration.swift
//  Concentration
//
//  Created by Xue Yu on 1/8/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter{ cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chosenCard(at index: Int) {
        // protects the index out of boundaray error
        assert(cards.indices.contains(index), "Concentration.chosenCard(at: (\(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match, since we have implemented == method
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0 ,"Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
    }
    
    // TODO: shuffle the cards
}


// return the one and only thing in the Collection or nil
extension Collection {
    var oneAndOnly: Element? {
        // count & first are both Collection methods, we can directly use them
        return count == 1 ? first : nil
    }
}

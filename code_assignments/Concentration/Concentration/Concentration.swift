//
//  Concentration.swift
//  Concentration
//
//  Created by XueYu on 1/9/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import Foundation

import Foundation

class Concentration {
    
    var cards = [Card]()
    
    var flips = 0
    var score = 0
    
    // use the index to record the card we have seen
    var previousSeenCards = [Int: Int]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chosenCard(at index: Int) {
        if !cards[index].isMatched {
            flips += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    // add 2 points for every match
                    score += 2
                }
                
                // penalizing 1 point for every previously seen card
                if previousSeenCards[index] != nil {
                    score -= 1
                }
                if previousSeenCards[matchIndex] != nil {
                    score -= 1
                }
                
                // record the seen cards in the dictionary
                previousSeenCards[index] = 1
                previousSeenCards[matchIndex] = 1
                    
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil          
                
            } else {
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
            cards += [card, card]
        }
        
        // TODO: Shuffle the cards
        for i in stride(from: cards.count - 1, to: 1, by: -1) {
            let j = Int(arc4random_uniform(UInt32(i+1)))
            if i != j {
                cards.swapAt(i, j)
            }
        }
    }

    
}

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

//
//  SetGame.swift
//  SetGame
//
//  Created by XueYu on 1/11/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import Foundation

struct SetGame {
    
    private(set) var flipCount = 0
    private(set) var score = 0
    private(set) var numberSets = 0
    
    private(set) var cardsOnTable = [SetCard]()
    private(set) var cardsSelected = [SetCard]()
    private(set) var cardsTryMatched = [SetCard]()
    private(set) var cardsRemoved = [SetCard]()
    
    private var deck = SetCardDeck()
    var deckCount: Int { return deck.cards.count }
    
    var isSet: Bool? {
        get {
            guard cardsTryMatched.count == 3 else { return nil }
            return SetCard.isSet(cards: cardsTryMatched)
        }
        set {
            if newValue != nil {
                if newValue! {  // cards matchs
                    score += Points.matchBonus
                    numberSets += 1
                } else {  // cards didn't match - Penalize
                    score -= Points.misMatchPenalty
                }
                
                cardsTryMatched = cardsSelected
                cardsSelected.removeAll()
            } else {
                cardsTryMatched.removeAll()
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cardsOnTable.indices.contains(index), "SetGame.chooseCard(at: \(index) : Choosen index out of range")
        
        let cardChoosen = cardsOnTable[index]
        if !cardsRemoved.contains(cardChoosen) && !cardsTryMatched.contains(cardChoosen) {
            if isSet != nil {
                // it is a set
                if isSet! { replaceOrRemove3Cards() }
                isSet = nil
            }
            if cardsSelected.count == 2, !cardsSelected.contains(cardChoosen) {
                cardsSelected += [cardChoosen]
                isSet = SetCard.isSet(cards: cardsSelected)
            } else {
                cardsSelected.inOut(element: cardChoosen)
            }
            flipCount += 1
            score -= Points.flipOverPenalty
        }
    }
    
    private mutating func replaceOrRemove3Cards() {
        if let take3Cards = take3FromDeck() {
            cardsOnTable.replace(elements: cardsTryMatched, with: take3Cards)
        } else {
            cardsOnTable.remove(elements: cardsTryMatched)
        }
        cardsRemoved += cardsTryMatched
        cardsTryMatched.removeAll()
    }
    
    
    private mutating func take3FromDeck() -> [SetCard]? {
        var threeCards = [SetCard]()
        for _ in 0...2 {
            if let card = deck.draw() {
                threeCards += [card]
            } else {
                return nil
            }
        }
        return threeCards
    }
    
    mutating func deal3(){
        if let deal3Cards = take3FromDeck() {
            cardsOnTable += deal3Cards
        }
    }
    
    var hints: [[Int]] {
        var hints = [[Int]]()
        if cardsOnTable.count > 2 {
            for i in 0..<cardsOnTable.count {
                for j in (i+1)..<cardsOnTable.count {
                    for k in (j+1)..<cardsOnTable.count {
                        let cards = [cardsOnTable[i], cardsOnTable[j], cardsOnTable[k]]
                        if SetCard.isSet(cards: cards) {
                            hints.append([i, j, k])
                        }
                    }
                }
            }
        }
        return hints
    }

    init() {
        for _ in 1...Constants.startNumberCards {
            if let card = deck.draw() {
                cardsOnTable += [card]
            }
        }
    }
    
    
    //------------------Constants ------------------
    private struct Points {
        static let matchBonus = 20
        static let misMatchPenalty = 10
        static var maxTimePenalty = 10
        static var flipOverPenalty = 1
    }
    
    private struct Constants {
        static let startNumberCards = 12
    }
}


extension Array where Element: Equatable {
    
    mutating func inOut(element: Element) {
        if let from = self.index(of: element) {
            self.remove(at: from)
        } else {
            self.append(element)
        }
    }
    
    
    mutating func remove(elements: [Element]) {
        self = self.filter{ !elements.contains($0) }
    }
    
    
    mutating func replace(elements: [Element], with new: [Element]) {
        guard elements.count == new.count else { return }
        for idx in 0..<new.count {
            if let indexMatched = self.index(of: elements[idx]) {
                self[indexMatched] = new[idx]
            }
        }
    }
}

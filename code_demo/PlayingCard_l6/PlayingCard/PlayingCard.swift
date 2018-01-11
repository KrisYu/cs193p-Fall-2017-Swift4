//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by XueYu on 1/9/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import Foundation

struct PlayingCard {
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String {
        case spades = "♠️"
        case hearts = "♥️"
        case clubs  = "♣️"
        case diamonds = "♦️"
        
        static var all = [Suit.spades, .hearts, .clubs, .diamonds]
    }
    
    
    // Rank is not well designed
    // i.e. the face(String) and the returned order
    enum Rank {
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J" : return 11
            case .face(let kind) where kind == "Q" : return 12
            case .face(let kind) where kind == "K" : return 13
            default: return 0
            }
        }
        
        // computed property
        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
        
    }
}

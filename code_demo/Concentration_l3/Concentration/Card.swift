//
//  Card.swift
//  Concentration
//
//  Created by Xue Yu on 1/8/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactroy = 0
    static func getUniqueIdentifier() -> Int {
        identifierFactroy += 1
        return identifierFactroy
    }
    
    init() {
        identifier = Card.getUniqueIdentifier()
    }
}

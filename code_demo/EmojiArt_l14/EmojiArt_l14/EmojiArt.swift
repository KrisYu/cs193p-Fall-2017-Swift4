//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by XueYu on 1/25/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import Foundation

// make this generates json
struct EmojiArt : Codable
{
    var url: URL
    var emojis = [EmojiInfo]()
    
    
    // model, make them int, no big deal
    struct EmojiInfo: Codable {
        let x: Int
        let y: Int
        let text: String
        let size: Int
    }
    
    // turn this to data, then we can save it and load it
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    // decode itself
    init?(json: Data) {
        if let newVale = try? JSONDecoder().decode(EmojiArt.self, from: json) {
            self = newVale
        } else {
            return nil
        }
    }
    
    init(url: URL, emojis: [EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
}

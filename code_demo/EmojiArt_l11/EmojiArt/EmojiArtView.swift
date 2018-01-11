//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Xue Yu on 1/1/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

// we'll draw the image in this view
class EmojiArtView: UIView
{
    
    // everytime we set the image, needs redraw
    var backgroundImage : UIImage? { didSet{ setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }


}

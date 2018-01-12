//
//  SetCardButton.swift
//  SetGame
//
//  Created by XueYu on 1/11/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardButton: BorderButton {
    
    var colors = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)]
    var alphas: [CGFloat] = [1.0, 0.40, 0.15]
    var strokeWidths: [CGFloat] = [-8, 8, 8]
    var symbols = ["▲", "●", "■"]
    
    var setCard: SetCard? {
        didSet {
            if let card = setCard {
                // --------- number & shape --------
                let symbol = symbols[card.shape.idx]
                switch card.number {
                case .v1: symbolString = "\(symbol)"
                case .v2: symbolString = "\(symbol)\n\(symbol)"
                case .v3: symbolString = "\(symbol)\n\(symbol)\n\(symbol)"
                }
                // -------- attributes: color & fill ---------
                attributes = [
                    .strokeColor: colors[card.color.idx],
                    .strokeWidth: strokeWidths[card.fill.idx],
                    .foregroundColor: colors[card.color.idx].withAlphaComponent(alphas[card.fill.idx])
                ]
                let attrString = NSAttributedString(string: symbolString, attributes: attributes)
                // -------------------------------------------
                setAttributedTitle(attrString, for: .normal)
                backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                isEnabled = true
            } else {
                setAttributedTitle(nil, for: .normal)
                setTitle(nil, for: .normal)
                backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                isEnabled = false
            }
        }
    }
    
    
    func setBorderColor(color: UIColor) {
        borderColor = color
        borderWidth = Constants.borderWidth
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    
    private func configure() {
        cornerRadius = Constants.cornerRadius
        titleLabel?.numberOfLines = 0
        borderColor = Constants.borderColor
        borderWidth = -Constants.borderWidth
    }
    
    
    
    
    
    private var symbolString = ""
    private var attributes = [NSAttributedStringKey: Any]()
    
    // ----------------Constants-----------
    private struct Constants {
        static let cornerRadius: CGFloat = 8.0
        static let borderWidth: CGFloat = 5.0
        static let borderColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
}

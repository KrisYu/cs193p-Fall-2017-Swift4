//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by XueYu on 1/9/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

// use @IBDesignable to let the interface builder compile the view
@IBDesignable
class PlayingCardView: UIView {
    
    // here rank & suit is for display purpose
    // it is total different from the model one
    // setNeedsDisplay() will call the draw rect since we need redraw if any of these things changed
    // setNeedsLayout() will call the layoutSubviews to re layout things
    // put @IBInspectable will make the var can be inspected in IB 
    @IBInspectable
    var rank: Int = 12 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var suit: String = "♥️" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
    // this will control the face card scale
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet { setNeedsDisplay() } }
    
    // since this controls the cardview itself, we put it in the view
    @objc func adbjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed,.ended :
            faceCardScale *= recognizer.scale
            // do not want it go exponentiation
            recognizer.scale = 1.0
        default:
            break
        }
        
    }
    
    private func centeredAttributeString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        // use this so the system settings will make scaleFont work
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        // makes the string centered, pay attention here it is NSMutableParagraphStyle
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }
    
    
    private var cornerString: NSAttributedString {
        return centeredAttributeString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }
    
    
    // avoid the init issue
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        // 0 means use any lines you need, an automatic way
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        
        // this will fix the issue of directly calling sizeToFit if the label has width it will make it taller
        label.frame.size = CGSize.zero
        // to fix the size
        label.sizeToFit()
        
        // if not face up, hide the labels
        label.isHidden = !isFaceUp
    }
    
    // make the UIFontMetrics respond to font change in system preference
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    
    // every time the bounds changed, we need to replace our label, and this method will be called every time bounds changed
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(lowerRightCornerLabel)
        
        // since the rotate happens on the origin, we need first to put the label at the origin
        // then rotate it
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .translatedBy(x: lowerRightCornerLabel.frame.width, y: lowerRightCornerLabel.frame.height)
            .rotated(by: CGFloat.pi)
        
        // move the lowerRightCornerLabel at the right position
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.width, dy: -lowerRightCornerLabel.frame.height)
        
    }
    
    // draws the non face cards nicely
    private func drawPips() {
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        
        func createPipsString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) {max($1.count, $0)})
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) {max($1.max() ?? 0, $0)})
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributeString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributeString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributeString(suit, fontSize: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height/2)
            let pipString = createPipsString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        let roundRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        // addClip will clip views just inside the roundRect
        roundRect.addClip()
        UIColor.white.setFill()
        roundRect.fill()
        
        // set PlayingCardView background color so we can see the white round rect
        // and we need to set the drawing be opaque
        
        
        
        if isFaceUp {
            // draw J,K,Q face cards beautifully
            // this UIImage( named: in: compatibleWith) will make the image also shows correctly in IB
            if let faceCardImage = UIImage(named: rankString+suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            } else {
                drawPips()
            }
        } else {
            if let cardBackImage = UIImage(named: "cardBack",in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
            }
        }
        
        
    }
    
}


extension PlayingCardView {
    
    // as a way to use constants
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}


extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

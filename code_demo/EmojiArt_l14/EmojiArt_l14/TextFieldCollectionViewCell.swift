//
//  TextFieldCollectionViewCell.swift
//  EmojiArt
//
//  Created by Xue Yu on 1/16/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    // closure, we set this in collection view controller, a nice trick way
    var resignationHandler: (()->Void)?
    
    // when it finishes editing, hit the return button, this function called
    func textFieldDidEndEditing(_ textField: UITextField) {
        // call this function when text field resigns
        resignationHandler?()
    }
    
    
    // press return and hide keyboard 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}

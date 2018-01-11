//
//  CassiniViewController.swift
//  Cassini_l9
//
//  Created by XueYu on 12/28/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // here we make each button with segue of its showing image name
        if let identifier = segue.identifier {
            // get url from the static dictionary
            if let url = DemoURLs.NASA[identifier]{
                if let imageVC = segue.destination.contents as? ImageViewController {
                    // set the model
                    imageVC.imageUrl = url
                    // set the title be the button title, this is good even it's localized
                    imageVC.title = (sender as? UIButton)?.currentTitle
                }
                
            }
        }
    }
    
}

// we embed the ImageViewController in NavigationController because we want a title for it, but then we break this, segue.destination as ImageViewController, we use

extension UIViewController {
    var contents: UIViewController{
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

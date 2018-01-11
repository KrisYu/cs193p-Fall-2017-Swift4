//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by XueYu on 1/10/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

// this better be a UITableViewController
// we want to make sure it is always showing the choose buttons first

class ConcentrationThemeChooserViewController:UIViewController, UISplitViewControllerDelegate  {
    
    let themes = [
        "Sports": "🏀🏈⚾️🎾⛹🏄🏋⛷🎿🎽",
        "Faces": "😘😩😊😁😏😢😆😬😉😂",
        "Animals": "🐻😼😽🐑🐲🕷🦑🦏🦊🦋🐖"
    ]
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    
    
    @IBAction func changeTheme(_ sender: Any) {
        // avoid segue because segue always make a new MVC
        // if theme exists
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        }
            
        else {
            // no theme exists, peform segue
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    // MARK: Navigation
    
    // strong, will stay in the heap
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    private var splitViewDetailConcentrationViewController : ConcentrationViewController? {
        // if I can find a ConcentrationViewController in my split view controller
        // this can only works on iPhone
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                // down cast segue.destination as ConcentrationViewController
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
    
    
    
}

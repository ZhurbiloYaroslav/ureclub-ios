//
//  FastInitialization.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 30.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

protocol FastInitialization {}

extension FastInitialization {
    
    public static func getInstance() -> Self? {
        
        if let instance = getInstanceFromStoryboard() {
            return instance
        } else if let instance = getInstanceFromNib() {
            return instance
        } else {
            return nil
        }
        
    }
    
}

// Helping variables and methods
extension FastInitialization {
    
    private static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    private static var storyboardOrNibName: String {
        return storyboardIdentifier.replacingOccurrences(of: "VC", with: "")
    }
    
    private static func getInstanceFromStoryboard() -> Self? {
        
        if Bundle.main.path(forResource: storyboardOrNibName, ofType: "storyboardc") != nil {
            let storyboard = UIStoryboard(name: storyboardOrNibName, bundle: nil)
            return getInstanceFrom(storyboard)
        } else if Bundle.main.path(forResource: storyboardIdentifier, ofType: "storyboardc") != nil {
            let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
            return getInstanceFrom(storyboard)
        } else {
            print("Storyboard with names \(storyboardOrNibName) and \(storyboardIdentifier) don't exist")
            return nil
        }
    }
    
    private static func getInstanceFromNib() -> Self? {
        
        if Bundle.main.path(forResource: storyboardOrNibName, ofType: "nib") != nil {
            let nib = Bundle.main.loadNibNamed(storyboardOrNibName, owner: nil, options: nil)
            return nib?.first as? Self
        } else if Bundle.main.path(forResource: storyboardIdentifier, ofType: "storyboardc") != nil {
            let nib = Bundle.main.loadNibNamed(storyboardIdentifier, owner: nil, options: nil)
            return nib?.first as? Self
        } else {
            print("Nib with names \(storyboardOrNibName) and \(storyboardIdentifier) don't exist")
            return nil
        }
    }
    
    private static func getInstanceFrom(_ storyboard: UIStoryboard) -> Self? {
        if let instance = storyboard.instantiateInitialViewController() as? Self {
            return instance
        } else if let instance = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self {
            debugLog("Please, set \(storyboardIdentifier) as Initial View Controller")
            return instance
        } else {
            print("No ID in Storyboard for \(storyboardIdentifier)")
            return nil
        }
    }
    
}

//
//  UIColor+Convenience.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/28/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

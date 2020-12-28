//
//  UITextField+DisableAutoFill.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/28/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}

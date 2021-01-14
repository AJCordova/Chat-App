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
    
    /**
     This code is added to address a secured text bug caused by the UITextField Autofill feature.
     - https://stackoverflow.com/questions/45452170/ios-11-disable-password-autofill-accessory-view-option
     - https://developer.apple.com/forums/thread/125717
     */
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}

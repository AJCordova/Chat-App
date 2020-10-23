//
//  Extensions.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/23/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    func base64Encoded() -> String?
    {
        return data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String?
    {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

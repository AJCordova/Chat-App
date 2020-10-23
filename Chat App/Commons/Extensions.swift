//
//  Extensions.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/23/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation

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

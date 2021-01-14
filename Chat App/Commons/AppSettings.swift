//
//  AppSettings.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/19/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation

struct AppSettings {
    
    static var isLoggedIn: Bool! {
       get {
        return UserDefaults.standard.bool(forKey: Constants.UserDefaultConstants.isLoggedIn)
       }
    }
    
    static var savedUser: User!
}

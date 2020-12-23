//
//  PubRegisterViewModel.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/14/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation

class PubRegisterViewModel {
    var encryptPassword: String = ""
    
    func processLogin(usernameInput: String?, passwordInput: String?) {
        guard let username = usernameInput else {return}
        guard let password = passwordInput else {return}
        
        if username.isEmpty && password.isEmpty {
            print("Empty")
        }
        else if isInputValid(username: username, password: password) {
            encryptPassword = password.base64Encoded()!
        } else {
            
            // show error message
        }
    }
    
    func isInputValid(username: String, password: String) -> Bool {
        if username.count < 8 || username.count > 16 {
            return false
        }
        if password.count < 8 || password.count > 16 {
            return false;
        }
        
        print("Show Input field", username, password)
        return true
    }
}

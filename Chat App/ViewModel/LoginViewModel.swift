//
//  LoginViewModel.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/17/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate
{
    func processUserCredentials(from username: String?, password: String?) -> Bool
}

class LoginViewModel: LoginViewModelDelegate
{
    //var delegate:
    
    /**
     Gets the user credentials from the text fields in SignUpViewController.
        - Parameter username: submitted user name
        - Parameter password: submitted password
        - Returns: bool
     */
    func processUserCredentials(from username: String?, password: String?) -> Bool {
        guard let userText = username else {return false}
        guard let passwordText = password else {return false}
        
        // validate user input
        if (validateUserInput(username: userText, password: passwordText))
        {
            // hash password
            // send parameters to API request
            return true
        }
        else
        {
            return false
        }
        
        //delegate?.getInfoBack(any: userText + passwordText)
    }
    
    /**
     Validates the user credentials if it meets the required character counts.
     - Parameter username: submitted user name
     - Parameter password: submitted password
     - Returns: bool
     */
    func validateUserInput(username: String?, password: String?) -> Bool
    {
        let usernameChars = username!.count
        let passwordChars = password!.count
        
        if (usernameChars < 8 && usernameChars > 16) { return false}
        if (passwordChars < 8 && passwordChars > 16) {return false}
        
        return true
    }
    
}



//
//  SignUpViewModel.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/17/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol SignUpViewModelDelegate {
    func processUserCredentials(from username: String?, password: String?) -> Bool
}

class SignUpViewModel: SignUpViewModelDelegate {
    
    var delegate: SignUpViewControllerDelegate?
    private var db = Firestore.firestore()
    
    /**
     Processes the user credentials for Sign Up.
        - Parameter username: submitted user name
        - Parameter password: submitted password
        - Returns: bool
     */
    func processUserCredentials(from username: String?, password: String?) -> Bool
    {
        guard let userText = username else {return false}
        guard let passwordText = password else {return false}
        
        if (validateUserInput(username: userText, password: passwordText))
        {
            var ref: DocumentReference? = nil
            
            ref = db.collection("Users").addDocument(
                data: [
                    "username" : userText,
                    "password" : passwordText])
            {
                err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            delegate?.getResult(result: true)
            return true
        }
        else
        {
            return false
        }
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

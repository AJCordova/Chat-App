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
    func processUserCredentials(from username: String?, password: String?)
}

class SignUpViewModel: SignUpViewModelDelegate {
    
    let task = DispatchGroup()
    var delegate: SignUpViewControllerDelegate?
    private var db = Firestore.firestore()
    
    /**
     Processes the user credentials for Sign Up.
        - Parameter username: submitted user name
        - Parameter password: submitted password
        - Returns: bool
     */
    func processUserCredentials(from username: String?, password: String?)
    {
        guard let userText = username else {return}
        guard let passwordText = password else {return}
        
        if (validateUserInput(username: userText, password: passwordText))
        {
            var ref: DocumentReference? = nil
            
            task.enter()
            ref = db.collection("Users").addDocument(
                data: [
                    "username" : userText,
                    "password" : passwordText])
            {
                err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    AppSettings.userID = ref!.documentID
                    print("Document added with ID: \(ref!.documentID)")
                }
                self.task.leave()
            }

            task.notify(queue: .main)
            {
                AppSettings.displayName = userText
                self.delegate?.getResult(result: true)
            }
        }
        else
        {
            return
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

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
    var usernameWarningMessage: String { get }
    var passwordWarningMessage: String { get }
}

class SignUpViewModel: SignUpViewModelDelegate {
    
    var usernameWarningMessage: String = "username warning"
    var passwordWarningMessage: String = "password warning"
    
    let task = DispatchGroup()
    var delegate: SignUpViewControllerDelegate?
    private var db = Firestore.firestore()
    
    //MARK: Delegate Methods

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
            print(validateUserInput(username: userText, password: passwordText))
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
                self.delegate?.isSignupSuccessful(result: true)
            }
        }
        else
        {
            self.delegate?.isSignupSuccessful(result: false)
            return
        }
    }
    
    /**
     Validates the user credentials if it meets the required character counts.
     - Parameter username: submitted user name
     - Parameter password: submitted password
     - Returns: bool
     */
    func validateUserInput(username: String, password: String) -> Bool
    {
        if username.isEmpty && password.isEmpty
        {
            return false;
        }

        if username.count < 8 || username.count > 16
        {
            return false
        }
        
        if password.count < 8 || password.count > 16
        {
            return false;
        }
        
        return true;
    }
}

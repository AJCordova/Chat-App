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

class SignUpViewModel: SignUpViewModelDelegate
{
    let task = DispatchGroup()
    var usernameWarningMessage: String = ""
    var passwordWarningMessage: String = ""
    var delegate: SignUpViewControllerDelegate?
    var model = SignupModel()
    
    private let collectionName = "Users"
    private var db = Firestore.firestore()
    private var referrence: CollectionReference? = nil
    private var docReferrence: DocumentReference? = nil
    private var isUserRegistered = false
    
    init()
    {
        self.referrence = db.collection(collectionName)
    }
    
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

        if userText.isEmpty && passwordText.isEmpty
        {
            usernameWarningMessage = model.textFieldEmptyWarningMessage
            passwordWarningMessage = model.textFieldEmptyWarningMessage
            self.delegate?.showWarnings()
            return
            
        }
        else
        {
            if (validateUserInput(username: userText, password: passwordText))
            {
                isUsernameRegistered(username: userText, password: passwordText)
            }
            else
            {
                usernameWarningMessage = model.invalidInputWarning
                passwordWarningMessage = model.invalidInputWarning
                self.delegate?.showWarnings()
                return
            }
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
    
    /**
     Register user credentials to firestore.
     - Parameter username: submitted user name
     - Parameter password: submitted password
     - Returns: bool
     */
    private func registerUser (username: String, password: String)
    {
        task.enter()
        if (self.isUserRegistered)
        {
            return
        }
        else
        {
            let encodedPassword: String = password.base64Encoded()!
            print (encodedPassword)
            docReferrence = db.collection(collectionName).addDocument(data: ["username": username,"password": password])
            { error in
                if let error = error
                {
                    print("Error adding user: \(error)")
                    self.usernameWarningMessage = self.model.invalidInputWarning
                    self.passwordWarningMessage = self.model.invalidInputWarning
                    self.delegate?.showWarnings()
                }
                else
                {
                    AppSettings.userID = self.docReferrence?.documentID
                    AppSettings.displayName = username
                }
            }
            task.leave()
        }
        
        task.notify(queue: .main)
        {
            NSLog("\(AppSettings.userID ?? "") \(AppSettings.displayName ?? "")")
            self.delegate?.isSignupSuccessful(result: true)
        }
    }
    
    /**
     Checks for username duplicates.
     - Parameter username: submitted user name
     - Parameter password: submitted password
     - Returns: bool
     */
    private func isUsernameRegistered (username: String, password: String)
    {
        task.enter()
        referrence?.whereField("username", isEqualTo: username).getDocuments()
        { (snapshot, err) in
            if let err = err
            {
                print("Error getting document: \(err)")
            }
            else if (snapshot!.isEmpty)
            {
                self.isUserRegistered = false
            }
            else
            {
                self.isUserRegistered = true
                self.usernameWarningMessage = self.model.duplicateUserWarning
                self.passwordWarningMessage = ""
                self.delegate?.showWarnings()
            }
            self.task.leave()
        }
        
        task.notify(queue: .global())
        {
            if !self.isUserRegistered
            {
                self.registerUser(username: username, password: password)
            }
        }
    }
}

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
    
    private var collectionName: String = ""
    private var db = Firestore.firestore()
    private var referrence: CollectionReference? = nil
    private var isUserRegistered = false
    private var model = SignupModel()
    
    
    init()
    {
        self.collectionName = model.CollectionReferrence
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
            usernameWarningMessage = Constants.invalidInputWarning
            passwordWarningMessage = Constants.invalidInputWarning
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
                usernameWarningMessage = Constants.invalidInputWarning
                passwordWarningMessage = Constants.invalidInputWarning
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
        var docReferrence: DocumentReference? = nil
        task.enter()
        if (self.isUserRegistered)
        {
            return
        }
        else
        {
            docReferrence = referrence!.addDocument(data: ["username": username,"password": password])
            { error in
                if let error = error
                {
                    NSLog("Error adding user: \(error)")
                    self.usernameWarningMessage = Constants.invalidInputWarning
                    self.passwordWarningMessage = Constants.invalidInputWarning
                    self.delegate?.showWarnings()
                }
                else
                {
                    NSLog("User added. Reference: \(docReferrence?.documentID ?? "")")
                    AppSettings.userID = docReferrence?.documentID
                    AppSettings.displayName = username
                }
                self.task.leave()
            }
        }
        
        task.notify(queue: .main)
        {
            NSLog("Current user: [\(AppSettings.userID ?? "")][ \(AppSettings.displayName ?? "")]")
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
        referrence?.whereField(model.FieldReferrence, isEqualTo: username).getDocuments()
        { (snapshot, err) in
            if let err = err
            {
                NSLog("isUsernameRegistered(): Error getting document: \(err)")
            }
            else if (snapshot!.isEmpty)
            {
                self.isUserRegistered = false
                NSLog("isUsernameRegistered(): No duplicates found")
            }
            else
            {
                NSLog("isUsernameRegistered(): duplicates found")
                self.isUserRegistered = true
                self.usernameWarningMessage = Constants.duplicateUserWarningLabel
                self.passwordWarningMessage = ""
                self.delegate?.showWarnings()
            }
            self.task.leave()
        }
        
        task.notify(queue: .global())
        {
            if !self.isUserRegistered
            {
                NSLog("isUsernameRegistered(): Proceed to registerUser()")
                self.registerUser(username: username, password: password)
            }
        }
    }
}

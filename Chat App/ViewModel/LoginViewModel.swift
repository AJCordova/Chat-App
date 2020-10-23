//
//  LoginViewModel.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/17/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol LoginViewModelDelegate
{
    func processUserCredentials(from username: String?, password: String?)
    var usernameWarningMessage: String { get }
    var passwordWarningMessage: String { get }
}

class LoginViewModel: LoginViewModelDelegate
{
    let task = DispatchGroup()
    var usernameWarningMessage: String = ""
    var passwordWarningMessage: String = ""
    var delegate: LoginViewControllerDelegate?
    
    private var collectionName = ""
    private var db = Firestore.firestore()
    private var referrence: CollectionReference? = nil
    private var docReferrence: DocumentReference? = nil
    private var isUserRegistered = false
    private let model = LoginModel()
    private var encodedPassword: String? = nil
    
    init()
    {
        self.collectionName = model.CollectionReferrence
        self.referrence = db.collection(collectionName)
    }
    
    /**
     Processes user credentials for login.
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
                encodedPassword = passwordText.base64Encoded()
                isUsernameRegistered(username: userText)
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
     This method vallidates the user credentials if it meets the required character counts.
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
     This method checks if user credentials exist.
     - Parameter username: submitted user name
     - Parameter password: submitted password
     - Returns: bool
     */
    private func isUsernameRegistered (username: String)
    {
        task.enter()
        referrence?.whereField(model.FieldReferrence, isEqualTo: username).getDocuments()
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
                if snapshot?.count == 1
                {
                    for document in snapshot!.documents
                    {
                        let data = document.data()
                        let hash: String = (data["password"] as? String)!
                        
                        if self.isValidHash(hash: hash.base64Encoded()!)
                        {
                            AppSettings.displayName = data["username"] as? String
                            AppSettings.userID = document.documentID
                            self.isUserRegistered = true
                            print(data)
                        }
                        else
                        {
                            print("Wrong password")
                        }
                    }
                }
                else
                {
                    // duplicate error
                    print("Multiple user entries found.")
                }
            }
            self.task.leave()
        }
        
        task.notify(queue: .main)
        {
            if self.isUserRegistered
            {
                self.delegate?.isLoginSuccessful(result: true)
            }
        }
    }
    
    /**
     This method checks the hashed user password input against the hash stored in the database.
     - Parameter hash: submitted user name
     - Returns: bool
     */
    private func isValidHash(hash: String) -> Bool
    {
        let userInput = encodedPassword?.base64Decoded()
        let hash = encodedPassword?.base64Decoded()
        
        if hash! == userInput!
        {
            return true
        }
        return false
    }
}

// MOVE TO DIFFERENT SWIFT FILE
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

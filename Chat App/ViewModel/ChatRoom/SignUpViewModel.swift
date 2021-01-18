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
    let task = DispatchGroup()
    var usernameWarningMessage: String = ""
    var passwordWarningMessage: String = ""
    var delegate: SignUpViewControllerDelegate?
    
    private var collectionName: String = ""
    private var db = Firestore.firestore()
    private var referrence: CollectionReference? = nil
    private var hasFoundDuplicates = false
    private var isSignupSuccess = false
    private var didEncounterError = false
    private var model = SignupModel()
    
    init() {
        self.collectionName = model.collectionReferrence
        self.referrence = db.collection(collectionName)
    }
    
    //MARK: Delegate Methods

    /**
     Processes the user credentials for Sign Up.
        - Parameter username: submitted user name
        - Parameter password: submitted password
        - Returns: bool
     */
    func processUserCredentials(from username: String?, password: String?) {
        guard let userText = username else {return}
        guard let passwordText = password else {return}

        if userText.isEmpty && passwordText.isEmpty {
            NSLog("Input Empty")
            usernameWarningMessage = Constants.DefaultStrings.invalidInputWarning
            passwordWarningMessage = Constants.DefaultStrings.invalidInputWarning
            self.delegate?.showWarnings()
            return
        }
        else {
            if (validateUserInput(username: userText, password: passwordText)) {
                isUsernameRegistered(username: userText, password: passwordText)
            }
            else {
                usernameWarningMessage = Constants.DefaultStrings.invalidInputWarning
                passwordWarningMessage = Constants.DefaultStrings.invalidInputWarning
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
    func validateUserInput(username: String, password: String) -> Bool {
        if username.count < 8 || username.count > 16 {
            return false
        }
        
        if password.count < 8 || password.count > 16 {
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
    private func registerUser (username: String, password: String) {
        var docReferrence: DocumentReference? = nil
        let hash = password.base64Encoded()
        task.enter()
        
        if self.didEncounterError {
            NSLog("Sign up failed")
            task.leave()
        }
        
        if (self.hasFoundDuplicates) {
            NSLog("Sign up failed")
            task.leave()
        }
        else {
            docReferrence = referrence!.addDocument(data: ["username": username, "password": hash!]) { error in
                if let error = error {
                    NSLog("Error adding user: \(error)")
                    self.usernameWarningMessage = Constants.DefaultStrings.invalidInputWarning
                    self.passwordWarningMessage = Constants.DefaultStrings.invalidInputWarning
                    self.didEncounterError = true
                }
                else {
                    guard let documentReference = docReferrence else { return }
                    NSLog("User added. Reference: \(documentReference.documentID)")
                    AppSettings.savedUser.uuid = documentReference.documentID
                    AppSettings.savedUser.username = username
                    self.isSignupSuccess = true
                }
                self.task.leave()
            }
        }
        
        task.notify(queue: .main) {
            if self.didEncounterError {
                NSLog("Firebase error")
                self.delegate?.isSignupSuccessful(result: false) // better have a generic error message. but sticking to specs for now.
            }
            else if self.hasFoundDuplicates {
                NSLog("Found user duplicates")
                self.delegate?.showWarnings()
            }
            else if self.isSignupSuccess {
                NSLog("Sign up Success")
                self.delegate?.isSignupSuccessful(result: true)
            }
            else {
                NSLog("Sign up failed")
                self.delegate?.isSignupSuccessful(result: false)
            }
        }
    }
    
    /**
     Checks for username duplicates.
     - Parameter username: submitted user name
     - Parameter password: submitted password
     - Returns: bool
     */
    private func isUsernameRegistered (username: String, password: String) {
        task.enter()
        referrence?.whereField(model.fieldReferrence, isEqualTo: username).getDocuments() { (snapshot, err) in
            if let err = err {
                NSLog("isUsernameRegistered(): Error getting document: \(err)")
                self.didEncounterError = true
            }
            else if (snapshot!.isEmpty) {
                NSLog("isUsernameRegistered(): No duplicates found")
            }
            else {
                NSLog("isUsernameRegistered(): duplicates found")
                self.usernameWarningMessage = Constants.DefaultStrings.duplicateUserWarningLabel
                self.passwordWarningMessage = ""
                self.hasFoundDuplicates = true
            }
            self.task.leave()
        }
        
        task.notify(queue: .global()) {
            NSLog("isUsernameRegistered(): Proceed to registerUser()")
            self.registerUser(username: username, password: password)
        }
    }
}

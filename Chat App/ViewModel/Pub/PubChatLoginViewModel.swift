//
//  PubChatLoginViewModel.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/11/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import RxSwift

class PubChatLoginViewModel {
    let task = DispatchGroup()

    var reference: CollectionReference? = nil
    var encodedPassword: String? = nil
    var db = Firestore.firestore()
    var retrievedHash: String = ""
    var isLoginSuccessful: Bool = false

    var UserManager: UserManagementProtocol
    
    init(userProtocol: UserManagementProtocol) {
        self.UserManager = userProtocol
        self.reference = db.collection(Constants.FirebaseStrings.userCollectionReference)
    }
    
    func processLogin(usernameInput: String?, passwordInput: String?) {
        guard let username = usernameInput else {return}
        guard let password = passwordInput else {return}
        
        if username.isEmpty && password.isEmpty {
            print("Empty")
        } else if isInputValid(username: username, password: password) {
            encodedPassword = password.base64Encoded()
            loginUser(username: username)
        } else {
           print("Invalid input")
        }
    }
    
    func isInputValid(username: String, password: String) -> Bool {
        print("Show Input field", username, password)
        if username.count < 8 || username.count > 16 {
            return false
        }
        if password.count < 8 || password.count > 16 {
            return false
        }
        return true;
    }
    
    func loginUser(username: String) {
        var retrievedHash: String = ""
        UserManager.UserSignIn(username: username, hash: encodedPassword!)
    }
    
    func verifyHash(retrievedHash: String) {
        if retrievedHash == encodedPassword {
            isLoginSuccessful = true
        }
        print(isLoginSuccessful)
    }
}

//
//  UserManagementService.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/21/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import RxCocoa

class UserManagementService: UserManagementProtocol {
    var isSigninValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var hasExitedPrematurely: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private let task = DispatchGroup()
    
    private static var db = Firestore.firestore()
    private var reference: CollectionReference? = db.collection(Constants.FirebaseStrings.userCollectionReference)
    private var docReference: DocumentReference? = nil
    private var userHash: String = ""
    private var receivedHash: String = ""
    private var username: String = ""
    private var receivedUUID: String = ""
    private var hasSignInFailed: Bool = false
    private var isUserFound: Bool = false
}

extension UserManagementService {
    /**
     Authenticates user against Firebase user collection.
     - Parameter username: submitted user name
     - Parameter hash: hashed submitted password
     */
    func userSignin(username: String, hash: String) {
        task.enter()
        print("Retrieving: \(username)")
        self.userHash = hash
        reference?.whereField(Constants.FirebaseStrings.userReference, isEqualTo: username)
            .getDocuments() { (snapshot, error) in
                if let err = error {
                    print("Error: \(err)")
                    self.hasSignInFailed = true
                } else {
                    for document in snapshot!.documents {
                        let data = document.data()
                        self.username = (data["username"] as? String)!
                        self.receivedHash = (data["password"] as? String)!
                        self.receivedUUID = (document.documentID)
                        self.isUserFound = true
                    }
                }
                self.task.leave()
            }
        
        task.notify(queue: .main) {
            if self.hasSignInFailed {
                self.hasExitedPrematurely.accept(true)
            } else if self.isUserFound {
                self.compareHash()
            } else {
                self.isSigninValid.accept(false)
            }
        }
    }
    
    /**
     Compares retrieved user hash and hash from user input.
     */
    func compareHash() {
        if userHash.elementsEqual(receivedHash) {
            saveUser()
            isSigninValid.accept(true)
            print(isSigninValid.value)
        } else {
            isSigninValid.accept(false)
        }
    }
    
    /**
     Saves user details to PubChat UserDefaults.
     */
    func saveUser() {
        let defaults = UserDefaults.standard
        defaults.setValue(self.username, forKey: Constants.UserDefaultConstants.userKey)
        defaults.setValue(self.receivedUUID, forKey: Constants.UserDefaultConstants.UUIDKey)
        defaults.setValue(true, forKey: Constants.UserDefaultConstants.isLoggedIn)
    }
}

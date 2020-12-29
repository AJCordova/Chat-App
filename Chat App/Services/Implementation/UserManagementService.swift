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
    var isSigninValid: PublishRelay<Bool>
    var hasExitedPrematurely: PublishRelay<Bool>
    var isUsernameAvailable: PublishRelay<Bool>
    var isRegisterSuccessful: PublishRelay<Bool>
    
//    var isSigninValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//    var isUsernameAvailable: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//    var hasExitedPrematurely: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//    var isRegisterSuccessful: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
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
    
    init() {
        isSigninValid = PublishRelay<Bool>()
        hasExitedPrematurely = PublishRelay<Bool>()
        isUsernameAvailable = PublishRelay<Bool>()
        isRegisterSuccessful = PublishRelay<Bool>()
    }
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
        userHash = hash
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
            saveUser(username: username, uuid: receivedUUID, isLoggedIn: true)
            isSigninValid.accept(true)
        } else {
            isSigninValid.accept(false)
        }
    }
    
    /**
     Saves user details to PubChat UserDefaults.
     */
    func saveUser(username: String, uuid: String, isLoggedIn: Bool) {
        let defaults = UserDefaults.standard
        defaults.setValue(username, forKey: Constants.UserDefaultConstants.userKey)
        defaults.setValue(uuid, forKey: Constants.UserDefaultConstants.UUIDKey)
        defaults.setValue(isLoggedIn, forKey: Constants.UserDefaultConstants.isLoggedIn)
    }
    
    // MARK: Register Users
    
    /**
     Checks if username is available.
     - Parameter userInput: Username input
     */
    func checkUsernameAvailability(userInput: String) {
        reference?.whereField(Constants.FirebaseStrings.userReference, isEqualTo: userInput)
            .getDocuments() { (snapshot, error) in
                if let err = error {
                    print("Error: \(err)")
                    self.hasExitedPrematurely.accept(true)
                } else {
                    if snapshot!.isEmpty {
                        self.isUsernameAvailable.accept(true)
                    } else {
                        self.isUsernameAvailable.accept(false)
                    }
                }
            }
    }
    
    /**
     Registers a new user in the server.
     - Parameter username: Username input
     - Parameter password: hashed password
     */
    func registerNewUser(username: String, password: String) {
        docReference = reference?.addDocument(data: ["username": username, "password": password]) { error in
            if let err = error {
                print("Error: \(err)")
                self.hasExitedPrematurely.accept(true)
            } else {
                let userID = self.docReference?.documentID
                guard let UUID = userID else {
                    self.hasExitedPrematurely.accept(true)
                    return
                }
                self.saveUser(username: username, uuid: UUID, isLoggedIn: true)
                self.isRegisterSuccessful.accept(true)
            }
        }
    }
        
}

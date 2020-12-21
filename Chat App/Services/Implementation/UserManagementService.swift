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
    lazy var isSignInSuccessful: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let task = DispatchGroup()
    
    private static var db = Firestore.firestore()
    private var reference: CollectionReference? = db.collection(Constants.FirebaseStrings.userCollectionReference)
    private var docReference: DocumentReference? = nil
    private var userHash: String = ""
    private var receivedHash: String = ""
    private var username: String = ""
    private var receivedUUID: String = ""
}

extension UserManagementService {
    
    func UserSignIn(username: String, hash: String) {
        task.enter()
        print("Retrieving: \(username)")
        self.userHash = hash
        reference?.whereField(Constants.FirebaseStrings.userReference, isEqualTo: username)
            .getDocuments() { (snapshot, error) in
                if let err = error {
                    print("Error: \(err)")
                } else {
                    for document in snapshot!.documents {
                        let data = document.data()
                        self.username = (data["username"] as? String)!
                        self.receivedHash = (data["password"] as? String)!
                        self.receivedUUID = (document.documentID)
                        print((data["password"] as? String)!)
                    }
                    self.isSignInSuccessful.accept(true)
                }
                self.task.leave()
            }
        task.notify(queue: .main) {
            print("Task Finished")
            print("Mounting user..\(self.username)")
            print("\(self.receivedUUID)")
            self.compareHash()
        }
    }
    
    func compareHash() {
        if userHash.elementsEqual(receivedHash) {
            saveUser()
            isSignInSuccessful.accept(true)
        } else {
            isSignInSuccessful.accept(false)
        }
    }
    
    func saveUser() {
        let defaults = UserDefaults.standard
        defaults.setValue(self.username, forKey: Constants.UserDefaultConstants.userKey)
        defaults.setValue(self.receivedUUID, forKey: Constants.UserDefaultConstants.UUIDKey)
        defaults.setValue(true, forKey: Constants.UserDefaultConstants.isLoggedIn)
    }
}

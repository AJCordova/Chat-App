//
//  UserManagementService.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/21/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import RxSwift

class UserManagementService: UserManagementProtocol {
    private static var db = Firestore.firestore()
    private var reference: CollectionReference? = db.collection(Constants.FirebaseStrings.userCollectionReference)
    private var docReference: DocumentReference? = nil
    private let task = DispatchGroup()
    
    func UserSignIn(username: String, hash: String) {
        task.enter()
        print("Retrieving: \(username)")
        reference?.whereField(Constants.FirebaseStrings.userReference, isEqualTo: username)
            .getDocuments() { (snapshot, error) in
                if let err = error {
                    print("Error: \(err)")
                } else {
                    for document in snapshot!.documents {
                        let data = document.data()
                        print((data["username"] as? String)!)
                        print((data["password"] as? String)!)
                    }
                }
                self.task.leave()
            }
        
        task.notify(queue: .main) {
            print("Task Finished")
        }
    }
    
    
}

//
//  ChatRoomViewModel.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/21/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol ChatRoomViewModelDelegate {
    func initializeListener()
    func sendMessage(_ message: Message)
}

class ChatRoomViewModel: ChatRoomViewModelDelegate {
    private let db = Firestore.firestore()
    private let task = DispatchGroup()
    
    private var reference: CollectionReference?
    private var messageThreadListener: ListenerRegistration?
    private var messageThread: [Message] = []
    var delegate: ChatRoomViewControllerDelegate?
    
    init() {
        self.reference = db.collection(ChatRoomModel.CollectionReferrence)
    }
    
    deinit {
        messageThreadListener?.remove()
    }
    
    //MARK: - Delegate Methods
    
    /**
      Initializes a listener to detect querries to  database.
    */
    func initializeListener() {
        messageThreadListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
          
            snapshot.documentChanges.forEach {
                change in
                self.handleDocumentChange(change)
            }
        }
    }
    
    /**
      Adds a new message document to the database collection.
         - Parameter message: message object
    */
    func sendMessage(_ message: Message) {
        reference?.addDocument(data: message.representation, completion: { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            self.delegate?.scrollToBottom()
        })
    }
    
    //MARK: - Private Methods
    
    /**
      Inserts a new  message  to the device collection.
         - Parameter message: message object
    */
    private func insertNewMessage(_ message: Message) {
        guard !messageThread.contains(message) else { return }
        
        messageThread.append(message)
        messageThread.sort()
        self.delegate?.updateMessageCollection(messageThread)
    }
    
    /**
     Gets the changed document from the change object to insert to the device con
     -   Parameter change: an object that contains the changed/added document.
    */
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document) else { return }
        
        switch change.type {
            case .added:
                self.insertNewMessage(message)
            default:
                break
        }
    }
}

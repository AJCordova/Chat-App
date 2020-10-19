//
//  ChatRoomViewController.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/19/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView

//final class ChatRoomViewController: UIViewController {}
final class ChatRoomViewController: MessagesViewController
{
    private var docReference: DocumentReference?
    var messagesThread: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Chat"

        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .lightGray
        messageInputBar.sendButton.setTitleColor(.green, for: .normal)
        
        messageInputBar.delegate = self as InputBarAccessoryViewDelegate
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        loadChatRoom()
    }
    
    //MARK: - Class Methods
    
    func loadChatRoom()
    {
        let db = Firestore.firestore()
        db.collection("Message Thread").getDocuments() { (messages, err) in
            if let err = err
            {
                print ("Error getting documents: \(err)")
                return
            }
            else
            {
                guard let messageCount = messages?.documents.count else
                {
                    return
                }
                
                if messageCount == 0
                {
                    self.createChatRoom()
                    
                }
                else if messageCount >= 1
                {
                    for message in messages!.documents
                    {
                        self.docReference = message.reference
                        message.reference.collection("Message Thread")
                            .order(by: "Date Created", descending: false)
                            .addSnapshotListener(includeMetadataChanges: true, listener:
                            { (threadQuery, error) in
                                
                                if let error = error
                                {
                                    NSLog("Error: \(error)")
                                    return
                                }
                                else
                                {
                                    self.messagesThread.removeAll()
                                    for message in threadQuery!.documents
                                    {
                                            let msg = Message(dictionary: message.data())
                                            self.messagesThread.append(msg!)
                                        print("Data: \(msg?.message ?? "No message found")")
                                    }
                                    
                                    self.messagesCollectionView.reloadData()
                                    self.messagesCollectionView.scrollToBottom(animated: true)
                                }
                            })
                        return
                    }
                    self.createChatRoom()
                }
                else
                {
                    NSLog("Load Chats Error")
                }
            }
        }
    }
    
    func createChatRoom()
    {
        let db = Firestore.firestore()
        db.collection("Message Thread2").addDocument(data: ["": ""])
        { (error) in
            
            if let error = error
            {
                print("Unable to create chat! \(error)")
                return
            }
            else
            {
                self.loadChatRoom()
            }
        }
    }
    
    //MARK: - Class Methods R.
    private func inserNewMessage (_ message: Message)
    {
        messagesThread.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async
        {
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    // saves message as new document in the message thread
    private func save (_ message: Message)
    {
        let data: [String: Any] =
        [
            "Message": "Test ",
            "Sender": "SCP-063"
        ]
        
        docReference?.collection("Message Thread").addDocument(data: data, completion:
        { (error) in
            if let error = error
            {
                print("Error Sending message: \(error)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
        })
    }
}

//MARK: - MessageInputBarDelegate
extension ChatRoomViewController: MessageInputBarDelegate
{
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
      let message = Message(id: "", date: "", message: text, senderName: "test")

      save(message)
      inserNewMessage(message)
      inputBar.inputTextView.text = ""
      messagesCollectionView.reloadData()
      messagesCollectionView.scrollToBottom(animated: true)
    }
}

//MARK: - MessageDataSource
extension ChatRoomViewController: MessagesDataSource
{
    func currentSender() -> SenderType
    {
        return Sender(id: "someID", displayName: "TestUser")
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType
    {
        return messagesThread[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int
    {
        if messagesThread.count == 0 {
            print("No messages to display")
            return 0
        } else {
            return messagesThread.count
        }
    }
}

//MARK: - MessagesLayoutDelegate
extension ChatRoomViewController: MessagesLayoutDelegate
{
    
}

//MARK: - MessageDisplayDelegate
extension ChatRoomViewController: MessagesDisplayDelegate
{
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.green : UIColor.green
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
      return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
      let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .pointedEdge)
    }
}

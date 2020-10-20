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
    private let currentUser = AppSettings.displayName
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    
    private var messageListener: ListenerRegistration?
    private var messagesThread: [Message] = []
    
    deinit
    {
      messageListener?.remove()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        reference = db.collection(["Message Thread","MessageThread", "Messages"].joined(separator: "/"))
        
        messageListener = reference?.addSnapshotListener
        { querySnapshot, error in
          guard let snapshot = querySnapshot else
          {
            print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
            return
          }
          
          snapshot.documentChanges.forEach
          { change in
            self.handleDocumentChange(change)
          }
        }
                
        self.title = "Chat App"
        navigationItem.setHidesBackButton(true, animated: false)
        
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .gray
        messageInputBar.sendButton.setTitleColor(.green, for: .normal)
        
        messageInputBar.delegate = self as InputBarAccessoryViewDelegate
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        //loadChatRoom()
    }
 
    //MARK: - Class Methods R.
    
    // saves message as new document in the message thread
    private func save (_ message: Message)
    {
        let messageData: [String: Any] =
        [
            "id" : message.messageId,
            "sendDate" : message.sendDate,
            "content" : message.content,
            "msgSender" : message.msgSender.displayName
        ]
        
        reference?.addDocument(data: messageData)
        { error in
          if let e = error
          {
            print("Error sending message: \(e.localizedDescription)")
            return
          }
          
          self.messagesCollectionView.scrollToBottom()
        }
    }
    
    private func insertNewMessage (_ message: Message)
    {
        guard !messagesThread.contains(message) else
        {
          return
        }
        
        messagesThread.append(message)
        messagesThread.sort()
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async
        {
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange)
    {
        guard let message = Message(document: change.document) else
        {
          return
        }

        switch change.type
        {
            case .added:
                insertNewMessage(message)
            default:
                break
        }
    }
}

//MARK: - InputBar Delegate
extension ChatRoomViewController: InputBarAccessoryViewDelegate
{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String)
    {
        let message = Message(content: text)

        save(message)
        inputBar.inputTextView.text = ""
    }
}

//MARK: - MessageDataSource
extension ChatRoomViewController: MessagesDataSource
{
    func currentSender() -> SenderType
    {
        NSLog(currentUser!)
        return Sender(id: currentUser!, displayName: currentUser!)
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
            print(messagesThread.count)
            return messagesThread.count
        }
    }
}

//MARK: Messages Layout
extension ChatRoomViewController: MessagesLayoutDelegate
{
  func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize
  {
    return .zero
  }
  
  func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize
  {
    return CGSize(width: 0, height: 8)
  }
  
  func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat
  {
    return 0
  }
  
}

//MARK: - MessageDisplayDelegate
extension ChatRoomViewController: MessagesDisplayDelegate
{
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor
    {
        return isFromCurrentSender(message: message) ? UIColor.green : UIColor.green
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool
    {
      return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle
    {
      let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .pointedEdge)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor
    {
        return .white
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

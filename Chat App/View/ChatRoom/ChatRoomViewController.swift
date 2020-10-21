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
        
        messageInputBar.delegate = self
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.sendButton.setTitleColor(.systemGreen, for: .normal)

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        {
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
            
        }
    }
 
    //MARK: - Class Methods R.
    
    // saves message as new document in the message thread
    private func save (_ message: Message)
    {
        reference?.addDocument(data: message.representation, completion:
        { error in
          if let e = error
          {
            print("Error sending message: \(e.localizedDescription)")
            return
          }
          
          self.messagesCollectionView.scrollToBottom()
        })
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
        
        print("doc change: \(message.msgSender)")
        
        switch change.type
        {
            case .added:
                self.insertNewMessage(message)
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
        return Sender(senderId: AppSettings.userID, displayName: AppSettings.displayName)
    }
    
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
      return messagesThread.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType
    {
        return messagesThread[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int
    {
        if messagesThread.count == 0 {
            return 0
        } else {
            return messagesThread.count
        }
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
    {
        return NSAttributedString(
            string: message.sender.displayName,
            attributes:
            [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ])
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat
    {
        return 9
    }
}

//MARK: Messages Layout
extension ChatRoomViewController: MessagesLayoutDelegate
{
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)
    {
        avatarView.isHidden = true
    }
  
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize
    {
        return CGSize(width: 0, height: 8)
    }
  
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat
    {
        return 0
    }
    
    private func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message){
            return LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        } else {
            return LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        }
    }
}

//MARK: - MessageDisplayDelegate
extension ChatRoomViewController: MessagesDisplayDelegate
{
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor
    {
        return isFromCurrentSender(message: message) ? UIColor(red: (158/255), green: (225/255), blue: (70/225), alpha: 1) : UIColor(red: (158/255), green: (225/255), blue: (70/255), alpha: 1) 
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

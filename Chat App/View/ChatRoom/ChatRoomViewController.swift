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

protocol ChatRoomViewControllerDelegate
{
    func updateMessageCollection(_ messageThread: [Message])
    func scrollToBottom()
}

final class ChatRoomViewController: MessagesViewController
{
    let viewModel = ChatRoomViewModel()
    var delegate: ChatRoomViewModelDelegate?
    
    private var messagesThread: [Message] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let logout = createLogoutButton()
        
        viewModel.delegate = self
        
        self.title = "Chat App"
        navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItem = logout
        
        viewModel.initializeListener()
 
        
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.delegate = self
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
    
    @objc func logoutChat()
    {
        AppSettings.displayName = ""
        AppSettings.userID = ""
        let indexViewController = IndexViewController()
        self.navigationController?.pushViewController(indexViewController, animated: true)
    }
    
    private func createLogoutButton() -> UIBarButtonItem
    {
        let btnProfile = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        btnProfile.setTitle("Log out", for: .normal)
        btnProfile.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btnProfile.titleEdgeInsets = UIEdgeInsetsMake(1,5,0,5)
        btnProfile.backgroundColor = UIColor.darkGray
        btnProfile.contentVerticalAlignment = .center
        btnProfile.contentHorizontalAlignment = .center
        btnProfile.titleLabel?.textAlignment = NSTextAlignment.center
        btnProfile.titleLabel?.adjustsFontSizeToFitWidth = true
        btnProfile.layer.cornerRadius = 4.0
        btnProfile.layer.masksToBounds = true
        btnProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.logoutChat)))
        
        let button = UIBarButtonItem(customView: btnProfile)
        return button
    }
}

//MARK: - InputBar Delegate
extension ChatRoomViewController: InputBarAccessoryViewDelegate
{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String)
    {
        let message = Message(content: text)
        viewModel.sendMessage(message)
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
    
    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message){
            return LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        } else {
            return LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40))
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

//MARK: - Delegate Implementation
extension ChatRoomViewController: ChatRoomViewControllerDelegate
{
    func scrollToBottom()
    {
        self.messagesCollectionView.reloadData()
        DispatchQueue.main.async
        {
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    func updateMessageCollection(_ messageThread: [Message])
    {
        self.messagesThread = messageThread
        scrollToBottom()
    }
}

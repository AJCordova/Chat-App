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

protocol ChatRoomViewControllerDelegate {
    func updateMessageCollection(_ messageThread: [Message])
    func scrollToBottom()
}

final class ChatRoomViewController: MessagesViewController {
    let viewModel = ChatRoomViewModel()
    var delegate: ChatRoomViewModelDelegate?
    
    private var messagesThread: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let logout = createLogoutButton()
        
        viewModel.delegate = self
        viewModel.initializeListener()
        
        self.title = Constants.DefaultStrings.navigationTitle
        self.navigationItem.rightBarButtonItem = logout
        navigationItem.setHidesBackButton(true, animated: false)
 
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.inputTextView.placeholder = "Start a new message"
        messageInputBar.inputTextView.backgroundColor = Constants.DefaultColors.messageInputBackground
        messageInputBar.inputTextView.layer.cornerRadius = 10.0
        messageInputBar.sendButton.backgroundColor = .darkGray
        messageInputBar.sendButton.setTitle("send", for: .normal)
        messageInputBar.sendButton.setTitleColor(.white, for: .normal)
        messageInputBar.sendButton.layer.cornerRadius = 10.0

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.setMessageIncomingAvatarSize(.zero)
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0) ))
    }
    
    /**
     Logs user out of the chat room. Clears AppSettings data for user info..
     */
    @objc func logoutChat() {
//        AppSettings.displayName = ""
//        AppSettings.userID = ""
        NSLog("ChatroomVC: Navigate to SignupVC")
        let signupViewController = IndexViewController()
        self.navigationController?.pushViewController(signupViewController, animated: true)
    }
    
    /**
     Creates the Navigationbar logout button.
     */
    private func createLogoutButton() -> UIBarButtonItem {
        let btnProfile = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 22))
        btnProfile.setTitle("Log out", for: .normal)
        btnProfile.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btnProfile.titleEdgeInsets = UIEdgeInsetsMake(1,5,0,5)
        btnProfile.backgroundColor = UIColor.darkGray
        btnProfile.contentVerticalAlignment = .center
        btnProfile.contentHorizontalAlignment = .center
        btnProfile.titleLabel?.textAlignment = NSTextAlignment.center
        btnProfile.titleLabel?.adjustsFontSizeToFitWidth = true
        btnProfile.layer.cornerRadius = 10.0
        btnProfile.layer.masksToBounds = true
        btnProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.logoutChat)))
        
        let button = UIBarButtonItem(customView: btnProfile)
        return button
    }
}

//MARK: - InputBar Delegate
extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(content: text)
        viewModel.sendMessage(message)
        inputBar.inputTextView.text = ""
    }
}

//MARK: - MessageDataSource
extension ChatRoomViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return Sender(senderId: "", displayName: "")
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
      return messagesThread.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messagesThread[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        if messagesThread.count == 0 {
            return 0
        } else {
            return messagesThread.count
        }
    }
}

//MARK: Messages Layout
extension ChatRoomViewController: MessagesLayoutDelegate {
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
  
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
  
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let value = message.sender.displayName
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 10)! ]
        let attributedString = NSAttributedString(string: value, attributes: attributes)
        return attributedString
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
}

//MARK: - MessageDisplayDelegate
extension ChatRoomViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? Constants.DefaultColors.messageBubbleColor : Constants.DefaultColors.messageBubbleColor
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
      return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
      let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .pointedEdge)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
}

//MARK: - Delegate Implementation
extension ChatRoomViewController: ChatRoomViewControllerDelegate {
    
    func scrollToBottom() {
        self.messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    func updateMessageCollection(_ messageThread: [Message]) {
        self.messagesThread = messageThread
        scrollToBottom()
    }
}

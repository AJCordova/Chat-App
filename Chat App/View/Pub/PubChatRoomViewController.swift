//
//  PubChatRoomViewController.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/9/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class PubChatRoomViewController: MessagesViewController {
    
    private var messagesThread: [Message] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        self.title = Constants.PubStrings.bannerLabel
        self.navigationItem.setHidesBackButton(true, animated: false)
        
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
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(
                                                                textAlignment: .right,
                                                                textInsets: UIEdgeInsets(
                                                                    top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(
                                                                textAlignment: .left,
                                                                textInsets: UIEdgeInsets(
                                                                    top: 0, left: 8, bottom: 0, right: 0) ))
    }
}

extension PubChatRoomViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
         let message = Message(content: text)
        // TODO: Message input and message data source will be filled in by viewmodel
        inputBar.inputTextView.text = ""
    }
}

extension PubChatRoomViewController: MessagesLayoutDelegate {
    func configureAvatarView(_ avatarView: AvatarView,
                             for message: MessageType,
                             at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    func footerViewSize(for message: MessageType,
                        at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let value = message.sender.displayName
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 10)!]
        let attributedString = NSAttributedString(string: value, attributes: attributes)
        return attributedString
    }
    func messageBottomLabelHeight(for message: MessageType,
                                  at indexPath: IndexPath,
                                  in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
}

extension PubChatRoomViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: "", displayName: "") // TODO: this data will be filled from user defaults
    }
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
      return messagesThread.count
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messagesThread[indexPath.section]
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messagesThread.count
    }
}

extension PubChatRoomViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType,
                         at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .green : .darkGray
    }
    func shouldDisplayHeader(for message: MessageType,
                             at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {
      return false
    }
    func messageStyle(for message: MessageType,
                      at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
      let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .pointedEdge)
    }
    func textColor(for message: MessageType,
                   at indexPath: IndexPath,
                   in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
}

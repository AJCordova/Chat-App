//
//  Message.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/19/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Firebase
import MessageKit
import FirebaseFirestore

struct Message: MessageType
{
    let id: String?
    let content: String
    let sendDate: Date
    let msgSender: SenderType
    
    var sender: SenderType
    {
        return msgSender
    }
    
    var messageId: String
    {
        return id ?? UUID().uuidString
    }
    
    var sentDate: Date
    {
        return sendDate
    }
    
    var kind: MessageKind
    {
        return .text(content)
    }

    init?(document: QueryDocumentSnapshot)
    {
      let data = document.data()
      
      guard let sentDate = data["sendDate"] as? Timestamp else {return nil}
      guard let senderName = data["msgSender"] as? String else {return nil}
      guard let senderID = data["senderID"] as? String else {return nil}
      guard let content = data["content"] as? String else {return nil}

      self.id = document.documentID
      self.sendDate = sentDate.dateValue()
      self.msgSender = Sender(senderId: senderID, displayName: senderName)
      print(self.msgSender)
      self.content = content
    }
    
    init(content: String)
    {
      self.msgSender = Sender(senderId: AppSettings.userID, displayName: AppSettings.displayName)
      self.content = content
      self.id = nil
      self.sendDate = Date()
    }
}

extension Message: DatabaseRepresentation
{
  var representation: [String : Any]
  {
    let rep: [String : Any] = [
        "sendDate": sentDate,
        "senderID": sender.senderId,
        "msgSender": sender.displayName,
        "content": content]
    
    return rep
  }
  
}

extension Message: Comparable {
  
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func < (lhs: Message, rhs: Message) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
}

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}

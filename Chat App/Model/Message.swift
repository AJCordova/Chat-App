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
import Foundation

struct Message: MessageType
{
    let id: String?
    let content: String
    let sendDate: Date
    let msgSender: Sender
    
    var sender: SenderType
    {
        return Sender(id:  AppSettings.displayName, displayName: AppSettings.displayName)
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
      guard let content = data["content"] as? String else {return nil}
        
      
      id = document.documentID
      self.sendDate = sentDate.dateValue()
      msgSender = Sender(id: senderName, displayName: senderName)
      self.content = content
      print(content)
      
    }
    
    init(content: String)
    {
      self.msgSender = Sender(id: AppSettings.displayName, displayName: AppSettings.displayName)
      self.content = content
      self.id = nil
      self.sendDate = Date()
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

//
//  Message.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/19/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import Firebase
import MessageKit
import UIKit

struct Message
{
    var id: String
    var date: String
    var message: String
    var senderName: String
    
    var Dictionary: [String: Any]
    {
        return [
            "id": id,
            "date": date,
            "message": message,
            "senderName": senderName]
    }
}

extension Message
{
    init?(dictionary: [String: Any])
    {
        guard let id = dictionary["id"] as? String,
              let date = dictionary["date"] as? String,
              let message = dictionary["message"] as? String,
              let senderName = dictionary["senderName"] as? String
        else {return nil}
        
        self.init(id: id, date: date, message: message, senderName: senderName)
    }
}

extension Message: MessageType
{
    var sentDate: Date
    {
        return Date()
    }

    var sender: SenderType
    {
        return Sender(id: senderName, displayName: senderName)
    }

    var messageId: String
    {
        return id
    }

    var kind: MessageKind
    {
        return .text(message)
    }
}

//
//  UserManagementProtocol.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/21/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import RxCocoa

protocol UserManagementProtocol { 
    /**
     Observable subject for searching the user collection.
     */
    var isSigninValid: BehaviorRelay<Bool> {get}
    
    /**
     Observable subject for escaping closure.
     */
    var hasExitedPrematurely: BehaviorRelay<Bool> {get}
    
    /**
     Sign in pubchat user. 
     */
    func userSignin(username: String, hash: String)
}

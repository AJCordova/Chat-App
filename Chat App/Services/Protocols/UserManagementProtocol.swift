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
     Observable subject for signin status.
     */
    var isSignInSuccessful: BehaviorRelay<Bool> {get}
    
    /**
     Sign in pubchat user. 
     */
    func UserSignIn(username: String, hash: String)
}

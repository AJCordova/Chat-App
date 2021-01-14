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
    var isSigninValid: PublishRelay<Bool> { get }
    
    /**
     Observable subject for escaping querries early.
     */
    var hasExitedPrematurely: PublishRelay<Bool> { get }
    
    /**
     Observable subject to confirm username availability.
     */
    var isUsernameAvailable: PublishRelay<Bool> { get }
    
    /**
     Observable subject to confirm user registration success.
     */
    var isRegisterSuccessful: PublishRelay<Bool> { get }
    
    /**
     Retrieves user information saved in the Keychain.
     */
    func getSavedUser() -> User?
    
    /**
     Sign in pubchat user. 
     */
    func userSignin(username: String, hash: String)
    
    /**
     Checks if username is available.
     */
    func checkUsernameAvailability(userInput: String)
    
    /**
     Register new user.
     */
    func registerNewUser(username: String, password: String)
}

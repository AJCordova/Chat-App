//
//  UserManagementServiceMock.swift
//  Chat AppTests
//
//  Created by Amiel Jireh Cordova on 12/22/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import RxCocoa
@testable import Chat_App

class UserManagementServiceMock: UserManagementProtocol {
    var isUsernameAvailable: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isRegisterSuccessful: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isSigninValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var hasExitedPrematurely: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isSignInSuccessful: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    func UserSignIn(username: String, hash: String) {
        isSignInSuccessful.accept(true)
    }
    
    func userSignin(username: String, hash: String) {}
    
    func checkUsernameAvailability(userInput: String) {}
    
    func registerNewUser(username: String, password: String) {}
}

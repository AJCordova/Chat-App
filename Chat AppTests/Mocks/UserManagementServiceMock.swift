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
    func getSavedUser() -> User? {
        return nil
    }
    
    var isSigninValid = PublishRelay<Bool>()
    var hasExitedPrematurely = PublishRelay<Bool>()
    var isUsernameAvailable = PublishRelay<Bool>()
    var isRegisterSuccessful = PublishRelay<Bool>()
    
    func UserSignIn(username: String, hash: String) {
        isSigninValid.accept(true)
    }
    
    func userSignin(username: String, hash: String) {}
    
    func checkUsernameAvailability(userInput: String) {}
    
    func registerNewUser(username: String, password: String) {}
}

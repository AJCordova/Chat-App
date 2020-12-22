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
    var isSignInSuccessful: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    func UserSignIn(username: String, hash: String) {
        isSignInSuccessful.accept(true)
    }
}

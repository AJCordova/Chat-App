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
    var isSignInSuccessful: BehaviorRelay<Bool> {get}
    func UserSignIn(username: String, hash: String)
}

//
//  PubChatLoginViewModel.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/11/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import RxSwift
import RxCocoa

class PubChatLoginViewModel {
    var encodedPassword: String? = nil
    var shouldShowLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var shouldProceedtoServer: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isInputEmpty: Bool = false

    var UserManager: UserManagementProtocol
    private let disposeBag = DisposeBag()
    
    init() {
        self.UserManager = UserManagementService()
        setUpObserver()
    }
    
    func processLogin(usernameInput: String?, passwordInput: String?) {
        guard let username = usernameInput else {return}
        guard let password = passwordInput else {return}
        if username.isEmpty && password.isEmpty {
            isInputEmpty = true
        } else if isInputValid(username: username, password: password) {
            encodedPassword = password.base64Encoded()
            loginUser(username: username)
        } else {
           print("Invalid input")
        }
    }
    
    func isInputValid(username: String, password: String) -> Bool {
        print("Show Input field", username, password)
        if username.count < 8 || username.count > 16 {
            return false
        }
        if password.count < 8 || password.count > 16 {
            return false
        }
        return true;
    }
    
    func loginUser(username: String) {
        shouldShowLoading.accept(true)
        UserManager.UserSignIn(username: username, hash: encodedPassword!)
    }
    
    func setUpObserver() {
        UserManager.isSignInSuccessful
            .asObservable()
            .subscribe(onNext: { [unowned self] isSuccessful in
                guard let isSuccessful: Bool = isSuccessful.rawValue as? Bool else { return }
                shouldShowLoading.accept(false)
                if isSuccessful {
                    shouldProceedtoServer.accept(true)
                } else {
                    // show errors 
                }
            })
            .disposed(by: disposeBag)
    }
}

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
    var shouldShowLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var shouldProceedtoServer: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var shouldShowWarning: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var isInputEmpty: Bool = false
    var encodedPassword: String? = nil
    var UserManager: UserManagementProtocol
    var warningText: String = ""
    
    private let disposeBag = DisposeBag()
    
    init() {
        self.UserManager = UserManagementService()
        setUpObserver()
    }
    
    /**
     Initiates user sign in process. 
     - Parameter username: submitted user name
     - Parameter password: submitted password
     - Returns: bool
     */
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
    
    /**
     Checks if user submitted input complies with input requirements.
     - Parameter username: submitted user name
     - Parameter password: submitted password
     - Returns: bool
     */
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
    
    /**
     Signs in the user with his submitted username and hashed password.
     - Parameter username: submitted user name
     */
    func loginUser(username: String) {
        shouldShowLoading.accept(true)
        UserManager.userSignin(username: username, hash: encodedPassword!)
    }
    
    /**
     Setup subject observer and conditional behavior.
     */
    private func setUpObserver() {
        UserManager.isSigninValid
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [unowned self] isSuccessful in
                guard let isSuccessful: Bool = isSuccessful.rawValue as? Bool else { return }
                shouldShowLoading.accept(false)
                if isSuccessful {
                    shouldProceedtoServer.accept(true)
                } else {
                    self.warningText = Constants.PubStrings.invalidLoginCredentials
                    shouldShowWarning.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        UserManager.hasExitedPrematurely
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [unowned self] hasExitedPrematurely in
                guard let hasExitedPrematurely: Bool = hasExitedPrematurely.rawValue as? Bool else { return }
                if hasExitedPrematurely {
                    self.warningText = Constants.PubStrings.serverUnavailableText
                    shouldShowWarning.accept(true)
                }
            })
            .disposed(by: disposeBag)
    }
}
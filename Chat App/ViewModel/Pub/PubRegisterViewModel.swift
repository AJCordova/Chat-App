//
//  PubRegisterViewModel.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/14/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PubRegisterViewModel {
    var isUsernameAvailable: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var doPasswordsMatch: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var passwordInput = ""
    var submittedUsername = ""
    
    private var userManager: UserManagementProtocol
    private let disposeBag = DisposeBag()
    
    init() {
        self.userManager = UserManagementService()
        setUpObservers()
    }
    
    /**
     Verifies that user input meets character limit requirements.
     - Parameter userInput: submitted user input.
     - Returns a Bool value that indicates if user input was valid. 
     */
    func verifyUserInput(userInput: String) -> Bool {
        if userInput.count >= 8 && userInput.count <= 16 {
            return true
        } else {
            return false
        }
    }
    
    /**
     Verifies that the inputted username is available for registration.
     - Parameter userInput: submitted user input.
     */
    func verifyUsernameAvailability(userInput: String) {
        userManager.checkUsernameAvailability(userInput: userInput)
    }
    
    /**
     Registers a new Pub user.
     */
    func registerUser() {
        let encodedPassword = hashPassword()
        userManager.registerNewUser(username: submittedUsername, password: encodedPassword)
    }
    
    /**
     Verifies that the inputted username is valid.
     - Parameter userInput: submitted user input.
     - Returns a password as a base64 string.
     */
    func hashPassword() -> String {
        return passwordInput.base64Encoded()!
    }
    
    /**
     Verifies that the password and confirm password fields contain the same values.
     - Parameter userInput: submitted user input.
     - Returns a Bool value that indicates that values match.
     */
    func verifyPasswordMatch(userInput: String!) -> Bool {
        guard let userInput = userInput else {return false}
        if userInput.elementsEqual(passwordInput) {
            return true
        } else {
            return false
        }
    }
    
    /**
     Sets up observable subjects for pub register viewcontroller.
     */
    func setUpObservers() {
        userManager.isUsernameAvailable
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] isAvailable in
                guard let self = `self`,
                      let isAvailable = isAvailable.rawValue as? Bool else {return}
                if isAvailable {
                    self.isUsernameAvailable.accept(true)
                } else {
                    self.isUsernameAvailable.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
}

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
    var shouldShowAlert: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var shouldShowLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isUsernameAvailable: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var shouldProceedtoServer: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var alertTitle = "Oh no"
    var alertMessage = "This service is currently unavailable. Please try again later."
    var alertActionLabel = "Ok"
    var passwordInput = ""
    var submittedUsername = ""
    var userManager: UserManagementProtocol
    
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
        shouldShowLoading.accept(true)
        let encodedPassword = hashPassword()
        userManager.registerNewUser(username: submittedUsername, password: encodedPassword)
    }
    
    /**
     Verifies that the inputted username is valid.
     - Parameter userInput: submitted user input.
     - Returns a base64 encoded string.
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
     Setup observers for user manager subjects.
     */
    private func setUpObservers() {
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
        
        userManager.hasExitedPrematurely
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] hasExitedPrematurely in
                guard let self = `self`,
                      let hasExitedPrematurely = hasExitedPrematurely.rawValue as? Bool else { return }
                if hasExitedPrematurely {
                    self.shouldShowLoading.accept(false)
                    self.shouldShowAlert.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        userManager.isRegisterSuccessful
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] isSuccessful in
                guard let self = `self`,
                      let isSuccessful = isSuccessful.rawValue as? Bool else { return }
                self.shouldShowLoading.accept(false)
                if isSuccessful {
                    self.shouldProceedtoServer.accept(true)
                }
            })
            .disposed(by: disposeBag)
    }
}

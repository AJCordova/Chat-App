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

protocol RegisterViewModelInputs {
    func verifyUsernameAvailability(userInput: String)
    func verifyUserInput(userInput: String) -> Bool
    func verifyPasswordMatch(userInput: String!, comparable: String!) -> Bool
    func registerUser(submittedUsername: String!, password: String!)
}

protocol RegisterViewModelOutputs {
    var alertTitle: String { get }
    var alertMessage: String { get }
    var alertActionLabel: String { get }
    var shouldShowAlert: PublishSubject<Bool> { get }
    var shouldShowLoading: PublishSubject<Bool> { get }
    var isUsernameAvailable: PublishSubject<Bool> { get }
    var shouldProceedtoServer: PublishSubject<Bool> { get }
}

protocol RegisterViewModelTypes {
    var inputs: RegisterViewModelInputs { get }
    var outputs: RegisterViewModelOutputs { get }
}

class PubRegisterViewModel: RegisterViewModelInputs, RegisterViewModelOutputs, RegisterViewModelTypes {
    var shouldShowAlert = PublishSubject<Bool>()
    var shouldShowLoading = PublishSubject<Bool>()
    var isUsernameAvailable = PublishSubject<Bool>()
    var shouldProceedtoServer = PublishSubject<Bool>()
    var inputs: RegisterViewModelInputs { return self }
    var outputs: RegisterViewModelOutputs { return self }
    
    var alertTitle = ""
    var alertMessage = ""
    var alertActionLabel = ""
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
        userInput.count >= 8 && userInput.count <= 16
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
    func registerUser(submittedUsername: String!, password: String!) {
        guard let submittedUsername = submittedUsername,
              let password = password else { return }
        shouldShowLoading.onNext(true)
        let encodedPassword = hashPassword(password: password)
        userManager.registerNewUser(username: submittedUsername, password: encodedPassword)
    }
    
    /**
     Verifies that the inputted username is valid.
     - Parameter userInput: submitted user input.
     - Returns a base64 encoded string.
     */
    func hashPassword(password: String) -> String {
        return password.base64Encoded()!
    }
    
    /**
     Verifies that the password and confirm password fields contain the same values.
     - Parameter userInput: submitted user input.
     - Returns a Bool value that indicates that values match.
     */
    func verifyPasswordMatch(userInput: String!, comparable: String!) -> Bool {
        guard let userInput = userInput,
              let comparable = comparable else { return false }
        if userInput.elementsEqual(comparable) {
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
            .subscribe(onNext: { [weak self] isAvailable in
                guard let self = `self`,
                      let isAvailable = isAvailable.rawValue as? Bool else { return }
                if isAvailable {
                    self.isUsernameAvailable.onNext(true)
                } else {
                    self.isUsernameAvailable.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        
        userManager.hasExitedPrematurely
            .asObservable()
            .subscribe(onNext: { [weak self] hasExitedPrematurely in
                guard let self = `self`,
                      let hasExitedPrematurely = hasExitedPrematurely.rawValue as? Bool else { return }
                if hasExitedPrematurely {
                    self.shouldShowLoading.onNext(false)
                    self.alertTitle = Constants.PubStrings.Warnings.genericErrorTitle
                    self.alertMessage = Constants.PubStrings.Warnings.genericErrorMessage
                    self.alertActionLabel = Constants.PubStrings.Generic.okButtonTitle
                    self.shouldShowAlert.onNext(true)
                }
            })
            .disposed(by: disposeBag)
        
        userManager.isRegisterSuccessful
            .asObservable()
            .subscribe(onNext: { [weak self] isSuccessful in
                guard let self = `self`,
                      let isSuccessful = isSuccessful.rawValue as? Bool else { return }
                self.shouldShowLoading.onNext(false)
                if isSuccessful {
                    self.shouldProceedtoServer.onNext(true)
                }
            })
            .disposed(by: disposeBag)
    }
}

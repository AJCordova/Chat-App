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
    var isUsernameValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isUsernameAvailable: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private var encryptPassword: String = ""
    private var userManager: UserManagementProtocol
    private let disposeBag = DisposeBag()
    
    init() {
        self.userManager = UserManagementService()
        setUpObservers()
    }
    
    func verifyUserInput(userInput: String) -> Bool {
        if userInput.count >= 8 && userInput.count <= 16 {
            return true
        } else {
            return false
        }
    }
    
    func verifyUsernameAvailability(userInput: String) {
        userManager.checkUsernameAvailability(userInput: userInput)
        print("check \(userInput): ")
    }
    
    func setUpObservers() {
        userManager.isUsernameAvailable
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] isAvailable in
                guard let self = `self`,
                      let isAvailable = isAvailable.rawValue as? Bool else {return}
                if isAvailable {
                    print(".... AVAILABLE")
                    self.isUsernameAvailable.accept(true)
                } else {
                    print(".... NOT AVAILABLE")
                    self.isUsernameAvailable.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
}

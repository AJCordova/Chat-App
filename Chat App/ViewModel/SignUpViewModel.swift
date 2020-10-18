//
//  SignUpViewModel.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/17/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation


protocol SignUpViewModelDelegate {
    func sendUserCredentials(from email: String?, password: String?)
}

class SignUpViewModel: SignUpViewModelDelegate {
    
    var delegate: SignUpViewControllerDelegate?
    
    func sendUserCredentials(from email: String?, password: String?) {
        guard let emailTextField = email else {return}
        guard let passwordField = password else {return}
        
        delegate?.getInfoBack(any: emailTextField + passwordField)
    }
}

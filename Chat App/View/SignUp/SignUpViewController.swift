//
//  SignUpViewController.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/17/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit

protocol SignUpViewControllerDelegate {
    
    func getInfoBack (any: String?)
}

class SignUpViewController: UIViewController, SignUpViewControllerDelegate {
    
    @IBOutlet weak var reusableForm: ReusableUserForm!
    
    let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        reusableForm.altCommand.setTitle("Login", for: .normal)
        reusableForm.mainCommand.setTitle("Sign Up", for: .normal)
        
        reusableForm.mainCommandInvoked = { [weak self] in
            NSLog("Main Command() -> Sign Up called.")
            self?.SignUp()
        }
        
        reusableForm.altCommandInvoked = { [weak self] in
            NSLog("Alt Command() -> Login Called")
            self?.GoToLogin()
        }
    }
    
    //MARK: - Navigation Methods
    func GoToLogin() {
        let loginViewController = LoginViewController()
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }

    func SignUp() {
        viewModel.processUserCredentials(from: reusableForm.usernameTextField.text, password: reusableForm.passwordTextField.text)
    }
    
    //MARK: - Protocol Implementation
    func getInfoBack(any: String?) {
        NSLog(any!)
    }
}

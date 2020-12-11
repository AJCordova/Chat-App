//
//  LoginViewController.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/17/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func isLoginSuccessful (result: Bool)
    func hideWarnings ()
    func showWarnings ()
}

class LoginViewController: UIViewController {
    @IBOutlet weak var reusableForm: ReusableUserForm!
    
    var attributedString = NSMutableAttributedString(string:"")
    var attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15.0),
                 NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any]
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.DefaultStrings.navigationTitle
        navigationItem.setHidesBackButton(true, animated: false)
        viewModel.delegate = self
        
        reusableForm.mainCommand.setTitle("Login", for: .normal)
        reusableForm.altCommand.setTitle("Sign Up", for: .normal)
        
        reusableForm.mainCommandInvoked = { [weak self] in
            NSLog("Main Command() -> Login called.")
            self?.hideWarnings()
            self?.login()
        }
        
        reusableForm.altCommandInvoked = { [weak self] in
            NSLog("Alt Command() -> Signup Called")
            self?.hideWarnings()
            self?.signup()
        }
        
        let buttonTitleStr = NSMutableAttributedString(string:"Sign up", attributes:attrs)
        attributedString.append(buttonTitleStr)
        reusableForm.altCommand.setAttributedTitle(attributedString, for: .normal)
    }
    
    func signup() {
        NSLog("LoginVC: Navigate to SignupVC")
        let signupviewController = SignUpViewController()
        self.navigationController?.pushViewController(signupviewController, animated: true)
    }

    func login() {
        viewModel.processUserCredentials(from: reusableForm.usernameTextField.text, password: reusableForm.passwordTextField.text)
    }
}

//MARK: - Protocol Implementation
extension LoginViewController: LoginViewControllerDelegate {
 
    func showWarnings() {
        reusableForm.usernameWarningLabel.text = viewModel.usernameWarningMessage
        reusableForm.passwordWarningLabel.text = viewModel.passwordWarningMessage
        reusableForm.usernameWarningLabel.isHidden = false
        reusableForm.passwordWarningLabel.isHidden = false
    }
    
    func hideWarnings() {
        reusableForm.usernameWarningLabel.isHidden = true
        reusableForm.passwordWarningLabel.isHidden = true
    }
    
    func isLoginSuccessful(result: Bool) {
        if (result) {
            NSLog("LoginVC: Navigate to ChatroomVC")
            let chatroomViewcontroller = ChatRoomViewController()
            self.navigationController?.pushViewController(chatroomViewcontroller, animated: true)
        }
        else {
            showWarnings()
        }
    }
}

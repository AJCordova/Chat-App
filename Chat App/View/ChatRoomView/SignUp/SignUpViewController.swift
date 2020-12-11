//
//  SignUpViewController.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/17/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit

protocol SignUpViewControllerDelegate {
    func isSignupSuccessful (result: Bool)
    func hideWarnings ()
    func showWarnings ()
}

class SignUpViewController: UIViewController {
    @IBOutlet weak var reusableForm: ReusableUserForm!
    
    var attributedString = NSMutableAttributedString(string:"")
    var attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15.0),
                 NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any]
    
    let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.DefaultStrings.navigationTitle
        navigationItem.setHidesBackButton(true, animated: false)
        viewModel.delegate = self
        
        reusableForm.mainCommand.setTitle("Sign Up", for: .normal)
        reusableForm.mainCommandInvoked = { [weak self] in
            NSLog("Main Command() -> Sign Up called.")
            self?.hideWarnings()
            self?.signup()
        }
        
        reusableForm.altCommandInvoked = { [weak self] in
            NSLog("Alt Command() -> Login Called")
            self?.hideWarnings()
            self?.login()
        }
        
        let buttonTitleStr = NSMutableAttributedString(string:"Login", attributes:attrs)
        attributedString.append(buttonTitleStr)
        reusableForm.altCommand.setAttributedTitle(attributedString, for: .normal)
    }
    
    func login() {
        NSLog("SignupVC: Navigate to LoginVC")
        let loginViewController = LoginViewController()
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }

    func signup() {
        viewModel.processUserCredentials(from: reusableForm.usernameTextField.text, password: reusableForm.passwordTextField.text)
    }
}

//MARK: - Protocol Implementation
extension SignUpViewController: SignUpViewControllerDelegate {
    
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
    
    func isSignupSuccessful(result: Bool) {
        if (result) {
            NSLog("ChatroomVC: Navigate to ChatroomVC")
            let chatroomViewcontroller = ChatRoomViewController()
            self.navigationController?.pushViewController(chatroomViewcontroller, animated: true)
        }
        else {
            showWarnings()
        }
    }
}

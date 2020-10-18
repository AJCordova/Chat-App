//
//  LoginViewController.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/17/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var reusableForm: ReusableUserForm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        reusableForm.usernameWarningLabel.isHidden = true
        reusableForm.passwordWarningLabel.isHidden = true
        reusableForm.usernameWarningLabel.text = "Invalid Value."
        reusableForm.passwordWarningLabel.text = "Invalid Value."
        
        reusableForm.mainCommand.setTitle("Login", for: .normal)
        reusableForm.altCommand.setTitle("Sign Up", for: .normal)
        
        reusableForm.mainCommandInvoked = { [weak self] in
            NSLog("Main Command() -> Login called.")
        }
        
        reusableForm.altCommandInvoked = { [weak self] in
            NSLog("Alt Command() -> Sign Up Called")
        }
    }

}

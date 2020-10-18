//
//  SignUpViewController.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/17/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var reusableForm: ReusableUserForm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        reusableForm.usernameWarningLabel.isHidden = false
        reusableForm.passwordWarningLabel.isHidden = false
        reusableForm.usernameWarningLabel.text = "Invalid Value."
        reusableForm.passwordWarningLabel.text = "Invalid Value."
        
        reusableForm.mainCommand.setTitle("Sign Up", for: .normal)
        reusableForm.altCommand.setTitle("Login", for: .normal)
        
        reusableForm.mainCommandInvoked = { [weak self] in
            NSLog("Main Command() -> Sign Up called.")
        }
        
        reusableForm.altCommandInvoked = { [weak self] in
            NSLog("Alt Command() -> Login Called")
        }
    }
    
    
}

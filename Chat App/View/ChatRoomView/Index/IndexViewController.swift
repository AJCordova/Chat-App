//
//  IndexViewController.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/16/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController {

    // MARK: - Buttons
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @IBAction func signupCommand() {
        NSLog("IndexVC: Navigate to SignupVC")
        let signUpViewController = SignUpViewController()
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @IBAction func loginCommand() {
        NSLog("IndexVC: Navigate to LoginVC")
        let loginViewController = LoginViewController()
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
}

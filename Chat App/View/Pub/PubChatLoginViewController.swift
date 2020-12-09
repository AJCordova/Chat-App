//
//  PubChat.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/7/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit

class PubChatLoginViewController: UIViewController {
    
    var bannerLabel: UILabel!
    var userNameField: UITextField!
    var passwordField: UITextField!
    var loginButton: UIButton!
    var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemGray3
        
        // Top Label
        bannerLabel = UILabel()
        bannerLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerLabel.textAlignment = .center
        bannerLabel.font = UIFont.systemFont(ofSize: 40)
        bannerLabel.text = "PUBCHAT" // TODO:  refactor to use constants file
        view.addSubview(bannerLabel)
        
        // Username textfield
        userNameField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userNameField.font = UIFont.systemFont(ofSize: 15)
        userNameField.backgroundColor = .white
        userNameField.borderStyle = .roundedRect
        userNameField.placeholder = "User name" // TODO: refactor to use constants file
        view.addSubview(userNameField)
        
        // password textfield
        passwordField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.font = UIFont.systemFont(ofSize: 15)
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry = true // masks inputted text
        passwordField.borderStyle = .roundedRect
        passwordField.placeholder = "Password" // TODO: refactor to use constants file
        view.addSubview(passwordField)
        
        // Login button
        loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Enter Server", for: .normal)
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 9.0
        loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        // Sign Up button
        registerButton = UIButton()
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .black
        registerButton.layer.cornerRadius = 9.0
        registerButton.addTarget(self, action: #selector(self.registerButtonTapped), for: .touchUpInside)
        view.addSubview(registerButton)
        
        NSLayoutConstraint.activate ([
            // banner label
            bannerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            bannerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // username
            userNameField.topAnchor.constraint(equalTo: bannerLabel.bottomAnchor, constant: 70),
            userNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            // password
            passwordField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 20),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            // login button
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 70),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            loginButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
    }
    
    @objc func loginButtonTapped() {
        print("PubChat Login button tapped.")
    }
    
    @objc func registerButtonTapped() {
        print("PubChat register button tapped.")
    }
}

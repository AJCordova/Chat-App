//
//  PubChatLoginViewController.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/7/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit

class PubChatLoginViewController: UIViewController {
    lazy var bannerLabel: UILabel = UILabel()
    lazy var userNameField: UITextField = UITextField()
    lazy var passwordField: UITextField = UITextField()
    lazy var loginButton: UIButton = UIButton()
    lazy var registerButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .systemGray3
        
        bannerLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerLabel.textAlignment = .center
        bannerLabel.font = .systemFont(ofSize: 40)
        bannerLabel.text = PubStrings.bannerLabel
        view.addSubview(bannerLabel)

        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userNameField.font = .systemFont(ofSize: 15)
        userNameField.backgroundColor = .white
        userNameField.borderStyle = .roundedRect
        userNameField.placeholder = PubStrings.usernamePlaceholderText
        view.addSubview(userNameField)

        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.font = .systemFont(ofSize: 15)
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        passwordField.placeholder = PubStrings.passwordPlaceholderText
        view.addSubview(passwordField)

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle(PubStrings.loginButtonTitle, for: .normal)
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 9.0
        loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)

        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle(PubStrings.registerButtonTitle, for: .normal)
        registerButton.backgroundColor = .black
        registerButton.layer.cornerRadius = 9.0
        registerButton.addTarget(self, action: #selector(self.registerButtonTapped), for: .touchUpInside)
        view.addSubview(registerButton)
        NSLayoutConstraint.activate([
            bannerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            bannerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userNameField.topAnchor.constraint(equalTo: bannerLabel.bottomAnchor, constant: 70),
            userNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            userNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            passwordField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 20),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
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
        let pubChatroomViewController = PubChatRoomViewController()
        self.navigationController?.pushViewController(pubChatroomViewController, animated: true)
    }
    @objc func registerButtonTapped() {
        print("PubChat register button tapped.")
    }
}

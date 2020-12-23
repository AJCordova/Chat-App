//
//  PubRegisterViewController.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/14/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit

class PubRegisterViewController: UIViewController {
    lazy var bannerLabel: UILabel = UILabel()
    lazy var formLabel: UILabel = UILabel()
    lazy var userNameField: UITextField = UITextField()
    lazy var passwordField: UITextField = UITextField()
    lazy var loginButton: UIButton = UIButton()
    lazy var registerButton: UIButton = UIButton()
    let viewModel = PubRegisterViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .systemGray3
        
        createSubViews()
        NSLayoutConstraint.activate([
            bannerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            bannerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            formLabel.topAnchor.constraint(equalTo: bannerLabel.bottomAnchor, constant: 35),
            formLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userNameField.topAnchor.constraint(equalTo: formLabel.bottomAnchor, constant: 35),
            userNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            userNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            passwordField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 20),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            registerButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 70),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            registerButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            
            loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 15),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
    }
    @objc func loginButtonTapped() {
        print("PubChat Login button tapped.")
//        viewModel.processLogin(usernameInput: userNameField.text, passwordInput: passwordField.text)
//        let pubChatroomViewController = PubChatRoomViewController()
//        self.navigationController?.pushViewController(pubChatroomViewController, animated: true)
    }
    @objc func registerButtonTapped() {
        print("PubChat register button tapped.")
        
        let pubChatroomViewController = PubRegisterViewController()
        self.navigationController?.pushViewController(pubChatroomViewController, animated: true)
    }
    
    func createSubViews() {
        createBannerLabel()
        createFormLabel()
        createUsernameField()
        createPasswordField()
        createRegisterButton()
        createLoginButton()
    }
    
    func createBannerLabel() {
        bannerLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerLabel.textAlignment = .center
        bannerLabel.font = .systemFont(ofSize: 40)
        bannerLabel.text = Constants.PubStrings.bannerLabel
        view.addSubview(bannerLabel)
    }
    
    func createFormLabel() {
        formLabel.translatesAutoresizingMaskIntoConstraints = false
        formLabel.textAlignment = .center
        formLabel.font = .systemFont(ofSize: 30)
        formLabel.text = "Register new user"
        view.addSubview(formLabel)
    }
    
    func createUsernameField() {
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userNameField.font = .systemFont(ofSize: 15)
        userNameField.backgroundColor = .white
        userNameField.borderStyle = .roundedRect
        userNameField.placeholder = Constants.PubStrings.usernamePlaceholderText
        view.addSubview(userNameField)
    }
    
    func createPasswordField() {
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.font = .systemFont(ofSize: 15)
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        passwordField.placeholder = Constants.PubStrings.passwordPlaceholderText
        view.addSubview(passwordField)
    }
    
    func createRegisterButton() {
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle(Constants.PubStrings.loginButtonTitle, for: .normal)
        registerButton.backgroundColor = .black
        registerButton.layer.cornerRadius = 9.0
        registerButton.addTarget(self, action: #selector(self.registerButtonTapped), for: .touchUpInside)
        view.addSubview(registerButton)
    }
    
    func createLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Register", for: .normal)
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 9.0
        loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
    }
}

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
    lazy var usernameField: UITextField = UITextField()
    lazy var usernameMessageLabel: UILabel = UILabel()
    lazy var passwordField: UITextField = UITextField()
    lazy var passwordMessageLabel: UILabel = UILabel()
    lazy var confirmPasswordField: UITextField = UITextField()
    lazy var confirmPasswordMessageLabel: UILabel = UILabel()
    lazy var loginButton: UIButton = UIButton()
    lazy var registerButton: UIButton = UIButton()
    let viewModel = PubRegisterViewModel()
    
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
            
            formLabel.topAnchor.constraint(equalTo: bannerLabel.bottomAnchor, constant: 20),
            formLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameField.topAnchor.constraint(equalTo: formLabel.bottomAnchor, constant: 20),
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            //username field message
            usernameMessageLabel.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 2),
            usernameMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameMessageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            passwordField.topAnchor.constraint(equalTo: usernameMessageLabel.bottomAnchor, constant: 5),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            //password field message
            passwordMessageLabel.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 2),
            passwordMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordMessageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            //confirm password
            confirmPasswordField.topAnchor.constraint(equalTo: passwordMessageLabel.bottomAnchor, constant: 5),
            confirmPasswordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            confirmPasswordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            //confirm password message
            confirmPasswordMessageLabel.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 2),
            confirmPasswordMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordMessageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            registerButton.topAnchor.constraint(equalTo: confirmPasswordMessageLabel.bottomAnchor, constant: 50),
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
        let loginViewController = PubChatLoginViewController()
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    @objc func registerButtonTapped() {
        print("PubChat register button tapped.")
    }
    
    func createSubViews() {
        createBannerLabel()
        createFormLabel()
        createUsernameField()
        createUsernameMessageLabel()
        createPasswordField()
        createPasswordMessageLabel()
        createConfirmPasswordField()
        createConfirmPasswordMessageLabel()
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
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.font = .systemFont(ofSize: 15)
        usernameField.backgroundColor = .white
        usernameField.borderStyle = .roundedRect
        usernameField.placeholder = Constants.PubStrings.usernamePlaceholderText
        view.addSubview(usernameField)
    }
    
    func createUsernameMessageLabel() {
        usernameMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameMessageLabel.font = .systemFont(ofSize: 12)
        usernameMessageLabel.textAlignment = .natural
        usernameMessageLabel.textColor = .red
        usernameMessageLabel.text = "XXXXX-XXXXX"
        view.addSubview(usernameMessageLabel)
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
    
    func createPasswordMessageLabel() {
        passwordMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordMessageLabel.font = .systemFont(ofSize: 12)
        passwordMessageLabel.textAlignment = .natural
        passwordMessageLabel.textColor = .red
        passwordMessageLabel.text = "XXXXX-XXXXX"
        view.addSubview(passwordMessageLabel)
    }
    
    func createConfirmPasswordField() {
        confirmPasswordField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordField.font = .systemFont(ofSize: 15)
        confirmPasswordField.backgroundColor = .white
        confirmPasswordField.isSecureTextEntry = true
        confirmPasswordField.borderStyle = .roundedRect
        confirmPasswordField.placeholder = Constants.PubStrings.confirmPasswordPlaceholder
        view.addSubview(confirmPasswordField)
    }
    
    func createConfirmPasswordMessageLabel() {
        confirmPasswordMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordMessageLabel.font = .systemFont(ofSize: 12)
        confirmPasswordMessageLabel.textAlignment = .natural
        confirmPasswordMessageLabel.textColor = .red
        confirmPasswordMessageLabel.text = "XXXXX-XXXXX"
        view.addSubview(confirmPasswordMessageLabel)
    }
    
    func createRegisterButton() {
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle(Constants.PubStrings.registerButtonTitle, for: .normal)
        registerButton.backgroundColor = .black
        registerButton.layer.cornerRadius = 9.0
        registerButton.addTarget(self, action: #selector(self.registerButtonTapped), for: .touchUpInside)
        view.addSubview(registerButton)
    }
    
    func createLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle(Constants.PubStrings.loginButtonTitle, for: .normal)
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 9.0
        loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
    }
}

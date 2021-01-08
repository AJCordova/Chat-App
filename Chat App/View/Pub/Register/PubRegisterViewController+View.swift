//
//  PubRegisterViewController+View.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 1/8/21.
//  Copyright © 2021 Cordova, Jireh. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

extension PubRegisterViewController {

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
        createLoadingIndicator()
    }
    
    func createBannerLabel() {
        bannerLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerLabel.textAlignment = .center
        bannerLabel.font = .systemFont(ofSize: 40)
        bannerLabel.text = Constants.PubStrings.Generic.bannerLabel
        
        view.addSubview(bannerLabel)
        
        bannerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
    }
    
    func createFormLabel() {
        formLabel.translatesAutoresizingMaskIntoConstraints = false
        formLabel.textAlignment = .center
        formLabel.font = .systemFont(ofSize: 20)
        formLabel.text = Constants.PubStrings.registerUserFormLabel
        
        view.addSubview(formLabel)
        
        formLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
    }
    
    func createUsernameField() {
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.font = .systemFont(ofSize: 15)
        usernameField.backgroundColor = .white
        usernameField.borderStyle = .roundedRect
        usernameField.placeholder = Constants.PubStrings.Generic.usernamePlaceholderText
        usernameField.autocorrectionType = .no
        usernameField.autocapitalizationType = .none
        usernameField.disableAutoFill()
        
        view.addSubview(usernameField)
        
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(formLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(55)
            make.height.equalTo(40)
        }
    }
    
    func createUsernameMessageLabel() {
        usernameMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameMessageLabel.font = .systemFont(ofSize: 12)
        usernameMessageLabel.textAlignment = .natural
        usernameMessageLabel.textColor = .red
        
        view.addSubview(usernameMessageLabel)
        
        usernameMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(1)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(55)
        }
    }
    
    func createPasswordField() {
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.font = .systemFont(ofSize: 15)
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        passwordField.placeholder = Constants.PubStrings.Generic.passwordPlaceholderText
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordField.disableAutoFill()
        
        view.addSubview(passwordField)
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(55)
            make.height.equalTo(40)
        }
    }
    
    func createPasswordMessageLabel() {
        passwordMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordMessageLabel.font = .systemFont(ofSize: 12)
        passwordMessageLabel.textAlignment = .natural
        passwordMessageLabel.textColor = .red
        
        view.addSubview(passwordMessageLabel)
        
        passwordMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(1)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(55)
        }
    }
    
    func createConfirmPasswordField() {
        confirmPasswordField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordField.font = .systemFont(ofSize: 15)
        confirmPasswordField.backgroundColor = .white
        confirmPasswordField.isSecureTextEntry = true
        confirmPasswordField.borderStyle = .roundedRect
        confirmPasswordField.placeholder = Constants.PubStrings.Generic.confirmPasswordPlaceholder
        confirmPasswordField.autocorrectionType = .no
        confirmPasswordField.autocapitalizationType = .none
        confirmPasswordField.disableAutoFill()
        
        view.addSubview(confirmPasswordField)
        
        confirmPasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(55)
            make.height.equalTo(40)
        }
    }
    
    func createConfirmPasswordMessageLabel() {
        confirmPasswordMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordMessageLabel.font = .systemFont(ofSize: 12)
        confirmPasswordMessageLabel.textAlignment = .natural
        confirmPasswordMessageLabel.textColor = .red
        
        view.addSubview(confirmPasswordMessageLabel)
        
        confirmPasswordMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordField.snp.bottom).offset(1)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(55)
        }
    }
    
    func createRegisterButton() {
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle(Constants.PubStrings.Generic.registerButtonTitle, for: .normal)
        registerButton.backgroundColor = .black
        registerButton.layer.cornerRadius = 9.0
        registerButton.addTarget(self, action: #selector(self.registerButtonTapped), for: .touchUpInside)
        
        view.addSubview(registerButton)
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordMessageLabel.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(55)
            make.height.equalTo(40)
        }
    }
    
    func createLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle(Constants.PubStrings.Generic.loginButtonTitle, for: .normal)
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 9.0
        loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(55)
            make.height.equalTo(40)
        }
    }
    
    func createLoadingIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

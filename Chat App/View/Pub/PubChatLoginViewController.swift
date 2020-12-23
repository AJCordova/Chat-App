//
//  PubChatLoginViewController.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/7/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PubChatLoginViewController: UIViewController {
    lazy var bannerLabel: UILabel = UILabel()
    lazy var usernameField: UITextField = UITextField()
    lazy var formWarningLabel: UILabel = UILabel()
    lazy var passwordField: UITextField = UITextField()
    lazy var loginButton: UIButton = UIButton()
    lazy var registerButton: UIButton = UIButton()
    lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .large)
    
    private let disposeBag = DisposeBag()
    private let UserManager = UserManagementService()
    private var viewModel: PubChatLoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        viewModel = PubChatLoginViewModel()
        setupObservers()
    }
    
    override func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .systemGray3
        
        createSubViews()
        NSLayoutConstraint.activate([
            bannerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            bannerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            formWarningLabel.topAnchor.constraint(equalTo: bannerLabel.bottomAnchor, constant: 50),
            formWarningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            formWarningLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            usernameField.topAnchor.constraint(equalTo: bannerLabel.bottomAnchor, constant: 70),
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 70),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            loginButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    @objc func loginButtonTapped() {
        print("PubChat Login button tapped.")
        viewModel.processLogin(usernameInput: usernameField.text, passwordInput: passwordField.text)
        formWarningLabel.isHidden = true
    }
    @objc func registerButtonTapped() {
        print("PubChat register button tapped.")
        let pubChatroomViewController = PubRegisterViewController()
        self.navigationController?.pushViewController(pubChatroomViewController, animated: true)
    }
    
    func createSubViews() {
        createBannerLabel()
        createFormWarningLabel()
        createUsernameField()
        createPasswordField()
        createLoginButton()
        createRegisterButton()
        createLoadingIndicator()
    }
    
    func createBannerLabel() {
        bannerLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerLabel.textAlignment = .center
        bannerLabel.font = .systemFont(ofSize: 40)
        bannerLabel.text = Constants.PubStrings.bannerLabel
        view.addSubview(bannerLabel)
    }
    
    func createUsernameField() {
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.font = .systemFont(ofSize: 15)
        usernameField.backgroundColor = .white
        usernameField.borderStyle = .roundedRect
        usernameField.placeholder = Constants.PubStrings.usernamePlaceholderText
        usernameField.autocorrectionType = .no
        usernameField.autocapitalizationType = .none
        view.addSubview(usernameField)
    }
    
    func createFormWarningLabel() {
        formWarningLabel.translatesAutoresizingMaskIntoConstraints = false
        formWarningLabel.font = .systemFont(ofSize: 12)
        formWarningLabel.textAlignment = .natural
        formWarningLabel.textColor = .red
        formWarningLabel.isHidden = true
        view.addSubview(formWarningLabel)
    }
    
    func createPasswordField() {
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.font = .systemFont(ofSize: 15)
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        passwordField.placeholder = Constants.PubStrings.passwordPlaceholderText
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        view.addSubview(passwordField)
    }
    
    func createLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle(Constants.PubStrings.loginButtonTitle, for: .normal)
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 9.0
        loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
    }
    
    func createRegisterButton() {
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle(Constants.PubStrings.registerButtonTitle, for: .normal)
        registerButton.backgroundColor = .black
        registerButton.layer.cornerRadius = 9.0
        registerButton.addTarget(self, action: #selector(self.registerButtonTapped), for: .touchUpInside)
        view.addSubview(registerButton)
    }
    
    func createLoadingIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
    }
    
    func setupObservers() {
        viewModel.shouldShowLoading
            .asObservable()
            .subscribe(onNext: { [weak self] showLoading in
                guard let shouldshowLoading: Bool = showLoading.rawValue as? Bool else { return }
                if shouldshowLoading {
                    self!.activityIndicator.startAnimating()
                } else {
                    self!.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.shouldProceedtoServer
            .asObservable()
            .subscribe(onNext: { [weak self] shouldProceed in
                guard let shouldProceed: Bool = shouldProceed.rawValue as? Bool else { return }
                if shouldProceed {
                    let viewController = PubChatRoomViewController()
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.shouldShowWarning
            .asObservable()
            .subscribe(onNext: { [unowned self] shouldShowWarning in
                guard let shouldShowWarning: Bool = shouldShowWarning.rawValue as? Bool else { return }
                if shouldShowWarning {
                    self.showWarning()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func showWarning() {
        formWarningLabel.text = viewModel.warningText
        formWarningLabel.isHidden = false
    }
}

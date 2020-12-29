//
//  PubRegisterViewController.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/14/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .large)
    
    private var viewModel: PubRegisterViewModel!
    private let disposeBag = DisposeBag()
    private let inputThrottleInMilliseconds = 700
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        viewModel = PubRegisterViewModel()
        setupTextChangedHandlers()
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
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func registerButtonTapped() {
        self.viewModel.submittedUsername = usernameField.text!
        self.viewModel.registerUser()
    }
    
    @objc func loginButtonTapped() {
        let loginViewController = PubChatLoginViewController()
        self.navigationController?.pushViewController(loginViewController, animated: true)
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
        createLoadingIndicator()
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
        formLabel.font = .systemFont(ofSize: 20)
        formLabel.text = Constants.PubStrings.registerUserFormLabel
        view.addSubview(formLabel)
    }
    
    func createUsernameField() {
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.font = .systemFont(ofSize: 15)
        usernameField.backgroundColor = .white
        usernameField.borderStyle = .roundedRect
        usernameField.placeholder = Constants.PubStrings.usernamePlaceholderText
        usernameField.autocorrectionType = .no
        usernameField.autocapitalizationType = .none
        usernameField.disableAutoFill()
        view.addSubview(usernameField)
    }
    
    func createUsernameMessageLabel() {
        usernameMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameMessageLabel.font = .systemFont(ofSize: 12)
        usernameMessageLabel.textAlignment = .natural
        usernameMessageLabel.textColor = .red
        view.addSubview(usernameMessageLabel)
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
        passwordField.disableAutoFill()
        view.addSubview(passwordField)
    }
    
    func createPasswordMessageLabel() {
        passwordMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordMessageLabel.font = .systemFont(ofSize: 12)
        passwordMessageLabel.textAlignment = .natural
        passwordMessageLabel.textColor = .red
        view.addSubview(passwordMessageLabel)
    }
    
    func createConfirmPasswordField() {
        confirmPasswordField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordField.font = .systemFont(ofSize: 15)
        confirmPasswordField.backgroundColor = .white
        confirmPasswordField.isSecureTextEntry = true
        confirmPasswordField.borderStyle = .roundedRect
        confirmPasswordField.placeholder = Constants.PubStrings.confirmPasswordPlaceholder
        confirmPasswordField.autocorrectionType = .no
        confirmPasswordField.autocapitalizationType = .none
        confirmPasswordField.disableAutoFill()
        view.addSubview(confirmPasswordField)
    }
    
    func createConfirmPasswordMessageLabel() {
        confirmPasswordMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordMessageLabel.font = .systemFont(ofSize: 12)
        confirmPasswordMessageLabel.textAlignment = .natural
        confirmPasswordMessageLabel.textColor = .red
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
    
    func createLoadingIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
    }
}

extension PubRegisterViewController {
    
    func setupTextChangedHandlers() {
        let usernameValid = usernameField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(inputThrottleInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.viewModel.verifyUserInput(userInput: $0!)
            }
        
        usernameValid
            .skip(1)
            .subscribe(onNext: { [weak self] in
                guard let self = `self` else { return }
                if $0 {
                    self.viewModel.verifyUsernameAvailability(userInput: self.usernameField.text!)
                } else {
                    self.usernameMessageLabel.textColor = .red
                    self.usernameMessageLabel.text = Constants.PubStrings.usernameInvalidMessage
                }
            })
            .disposed(by: disposeBag)

        let passwordValid = passwordField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(inputThrottleInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.viewModel.verifyUserInput(userInput: $0!)
            }
        
        passwordValid
            .skip(1)
            .subscribe(onNext: { [weak self] in
                guard let self = `self` else { return }
                if $0 {
                    self.passwordMessageLabel.textColor = .blue
                    self.passwordMessageLabel.text = Constants.PubStrings.passwordValidMessage
                    self.viewModel.passwordInput = self.passwordField.text!
                } else {
                    self.passwordMessageLabel.textColor = .red
                    self.passwordMessageLabel.text = Constants.PubStrings.passwordInvalidMessage
                }
            })
            .disposed(by: disposeBag)

        let confirmPasswordValid = confirmPasswordField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(inputThrottleInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.viewModel.verifyPasswordMatch(userInput: $0!)
            }
        
        confirmPasswordValid
            .skip(1)
            .subscribe(onNext: { [weak self] in
                guard let self = `self` else { return }
                if $0 {
                    self.confirmPasswordMessageLabel.textColor = .blue
                    self.confirmPasswordMessageLabel.text = Constants.PubStrings.passwordMatchMessage
                } else {
                    self.confirmPasswordMessageLabel.textColor = .red
                    self.confirmPasswordMessageLabel.text = Constants.PubStrings.passwordMismatchMessage
                }
            })
            .disposed(by: disposeBag)
        
        let everythingValid = Observable
            .combineLatest(usernameValid, passwordValid, confirmPasswordValid) {
                $0 && $1 && $2
            }
        
        everythingValid
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func setupObservers() {
        viewModel.shouldShowLoading
            .asObservable()
            .skip(1)
            .subscribe(onNext: {[weak self] showLoading in
                guard let self = `self`,
                      let shouldshowLoading = showLoading.rawValue as? Bool else { return }
                if shouldshowLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isUsernameAvailable
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] in
                guard let self = `self` else {return}
                if $0 {
                    self.usernameMessageLabel.textColor = .blue
                    self.usernameMessageLabel.text = Constants.PubStrings.usernameValidMessage
                } else {
                    self.usernameMessageLabel.textColor = .red
                    self.usernameMessageLabel.text = Constants.PubStrings.usernameTakenMessage
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.shouldShowAlert
            .asObservable()
            .subscribe(onNext: { [weak self] shouldShowAlert in
                guard let self = `self`,
                      let shouldShowAlert = shouldShowAlert.rawValue as? Bool else { return }
                if shouldShowAlert {
                    self.showAlert()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.shouldProceedtoServer
            .asObservable()
            .subscribe(onNext: { [weak self] shouldProceed in
                guard let self = `self`,
                      let shouldProceed = shouldProceed.rawValue as? Bool else { return }
                if shouldProceed {
                    let viewController = PubChatRoomViewController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: viewModel.alertTitle,
                                      message: viewModel.alertMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: viewModel.alertActionLabel, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

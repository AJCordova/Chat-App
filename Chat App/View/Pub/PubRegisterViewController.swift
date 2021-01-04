//
//  PubRegisterViewController.swift
//  Chat App
//
//  Created by Amiel Jireh Cordova on 12/14/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit
import SnapKit
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
    }
    
    @objc func registerButtonTapped() {
        self.viewModel.submittedUsername = usernameField.text!
        self.viewModel.inputs.registerUser()
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

extension PubRegisterViewController {
    
    func setupTextChangedHandlers() {
        let usernameValid = usernameField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(inputThrottleInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.viewModel.inputs.verifyUserInput(userInput: $0!)
            }
        
        usernameValid
            .skip(1)
            .subscribe(onNext: { [weak self] in
                guard let self = `self` else { return }
                if $0 {
                    self.viewModel.inputs.verifyUsernameAvailability(userInput: self.usernameField.text!)
                } else {
                    self.usernameMessageLabel.textColor = .red
                    self.usernameMessageLabel.text = Constants.PubStrings.Warnings.usernameInvalidMessage
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
                self.viewModel.inputs.verifyUserInput(userInput: $0!)
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
                    self.passwordMessageLabel.text = Constants.PubStrings.Warnings.passwordInvalidMessage
                }
            })
            .disposed(by: disposeBag)

        let confirmPasswordValid = confirmPasswordField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .throttle(.milliseconds(inputThrottleInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.viewModel.inputs.verifyPasswordMatch(userInput: $0!)
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
                    self.confirmPasswordMessageLabel.text = Constants.PubStrings.Warnings.passwordMismatchMessage
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
        viewModel.outputs.shouldShowLoading
            .asObservable()
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
        
        viewModel.outputs.isUsernameAvailable
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = `self` else {return}
                if $0 {
                    self.usernameMessageLabel.textColor = .blue
                    self.usernameMessageLabel.text = Constants.PubStrings.usernameValidMessage
                } else {
                    self.usernameMessageLabel.textColor = .red
                    self.usernameMessageLabel.text = Constants.PubStrings.Warnings.usernameTakenMessage
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.shouldShowAlert
            .asObservable()
            .subscribe(onNext: { [weak self] shouldShowAlert in
                guard let self = `self`,
                      let shouldShowAlert = shouldShowAlert.rawValue as? Bool else { return }
                if shouldShowAlert {
                    self.showAlert()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.shouldProceedtoServer
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

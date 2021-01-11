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
        guard let username = usernameField.text,
              let password = passwordField.text else { return }
        self.viewModel.inputs.registerUser(submittedUsername: username, password: password)
    }
    
    @objc func loginButtonTapped() {
        let loginViewController = PubChatLoginViewController()
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
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
            .subscribe(onNext: { [weak self] isValid in
                guard let self = `self` else { return }
                if isValid {
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
            .subscribe(onNext: { [weak self] isValid in
                guard let self = `self` else { return }
                if isValid {
                    self.passwordMessageLabel.textColor = .blue
                    self.passwordMessageLabel.text = Constants.PubStrings.passwordValidMessage
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
            .map { [unowned self] userInput in
                self.viewModel.inputs.verifyPasswordMatch(userInput: userInput!, comparable: self.passwordField.text!)
            }
        
        confirmPasswordValid
            .skip(1)
            .subscribe(onNext: { [weak self] isValid in
                guard let self = `self` else { return }
                if isValid {
                    self.confirmPasswordMessageLabel.textColor = .blue
                    self.confirmPasswordMessageLabel.text = Constants.PubStrings.passwordMatchMessage
                } else {
                    self.confirmPasswordMessageLabel.textColor = .red
                    self.confirmPasswordMessageLabel.text = Constants.PubStrings.Warnings.passwordMismatchMessage
                }
            })
            .disposed(by: disposeBag)
        
        let everythingValid = Observable
            .combineLatest(usernameValid, passwordValid, confirmPasswordValid).map { $0 && $1 && $2 }
        
        everythingValid
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func setupObservers() {
        viewModel.outputs.shouldShowLoading
            .asObservable()
            .subscribe(onNext: { [weak self] showLoading in
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
            .subscribe(onNext: { [weak self] isUsernameAvailable in
                guard let self = `self` else {return}
                if isUsernameAvailable {
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
        let alert = UIAlertController(title: viewModel.outputs.alertTitle,
                                      message: viewModel.outputs.alertMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: viewModel.outputs.alertActionLabel, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

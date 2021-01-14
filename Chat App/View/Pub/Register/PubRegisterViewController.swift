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
        usernameField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(inputThrottleInMilliseconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] userInput in
                self.viewModel.inputs.usernameChanged(userInput: userInput!)
            })
            .disposed(by: disposeBag)
        
        passwordField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(inputThrottleInMilliseconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] userInput in
                self.viewModel.inputs.passwordChanged(userInput: userInput!)
            })
            .disposed(by: disposeBag)
        
        confirmPasswordField
            .rx
            .text
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(inputThrottleInMilliseconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] userInput in
                guard let passwordInput = passwordField.text,
                      let userInput = userInput else { return }
                if passwordInput.isEmpty {
                    return
                } else {
                    self.viewModel.inputs.verifyPasswordMatch(userInput: userInput, comparable: passwordInput)
                }
            })
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
        
        viewModel.outputs.isUsernameAvailable
            .filter { $0 }
            .map { _ in UIColor.blue }
            .bind(to: usernameMessageLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isUsernameAvailable
            .filter { !$0 }
            .map { _ in UIColor.red }
            .bind(to: usernameMessageLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.outputs.usernameFieldLabel
            .bind(to: usernameMessageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isUsernameValid
            .filter { !$0 }
            .map { _ in UIColor.red }
            .bind(to: usernameMessageLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.outputs.passwordFieldLabel
            .bind(to: passwordMessageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isPasswordValid
            .filter { $0 }
            .map { _ in UIColor.blue }
            .bind(to: passwordMessageLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isPasswordValid
            .filter { !$0 }
            .map { _ in UIColor.red }
            .bind(to: passwordMessageLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.outputs.confirmPasswordFieldLabel
            .asObservable()
            .bind(to: confirmPasswordMessageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.doPasswordsMatch
            .filter { $0 }
            .map { _ in UIColor.blue }
            .bind(to: confirmPasswordMessageLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.outputs.doPasswordsMatch
            .filter { !$0 }
            .map { _ in UIColor.red }
            .bind(to: confirmPasswordMessageLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.outputs.shouldEnableRegisterButton
            .bind(to: registerButton.rx.isEnabled)
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

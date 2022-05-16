//
//  SigninViewController.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/11/22.
//

import Foundation
import UIKit
import RxSwift
import SnapKit
import EventKitUI

class SigninViewController: UIViewController {
    
    private var viewModel: SigninViewModelTypes
    
    lazy var emailTextField: UITextField = UITextField()
    lazy var emailErrorLabel: UILabel = UILabel()
    lazy var passwordTextField: UITextField = UITextField()
    lazy var passwordErrorLabel: UILabel = UILabel()
    lazy var signinButton: UIButton = UIButton()
    lazy var signupButton: UIButton = UIButton()
    lazy var disposeBag = DisposeBag()
    
    
    init(viewModel: SigninViewModelTypes) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

// MARK: Views set-up
extension SigninViewController {
    func setupViews() {
        setupEmailTextField()
        setupEmailErrorLabel()
        setupPasswordTextField()
        setupPasswordErrorLabel()
        setupSigninButton()
        setupSignupButton()
    }
    
    private func setupEmailTextField() {
        emailTextField.placeholder = "Enter email"
        emailTextField.layer.borderColor = UIColor.systemGray3.cgColor
        emailTextField.layer.borderWidth = 0.5
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        view.addSubview(emailTextField)

        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func setupEmailErrorLabel() {
        emailErrorLabel.textColor = .systemRed
        emailErrorLabel.font = .systemFont(ofSize: 10)
        view.addSubview(emailErrorLabel)
        
        emailErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom)
            make.left.right.equalTo(emailTextField)
        }
    }
    
    private func setupPasswordTextField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.layer.borderColor = UIColor.systemGray3.cgColor
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        view.addSubview(passwordTextField)
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(50)
        }
    }
    
    private func setupPasswordErrorLabel() {
        passwordErrorLabel.textColor = .systemRed
        passwordErrorLabel.font = .systemFont(ofSize: 10)
        view.addSubview(passwordErrorLabel)
        
        passwordErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.left.right.equalTo(emailTextField)
        }
    }
    
    private func setupSigninButton() {
        signinButton.backgroundColor = .systemBlue
        signinButton.setTitle("Sign in", for: .normal)
        signinButton.layer.cornerRadius = 9.0
        signinButton.isEnabled = false
        view.addSubview(signinButton)
        
        signinButton.snp.makeConstraints { make in
            make.top.equalTo(passwordErrorLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(50)
        }
    }
    
    private func setupSignupButton() {
        signupButton.backgroundColor = .systemBlue
        signupButton.setTitle("Sign up", for: .normal)
        signupButton.layer.cornerRadius = 9.0
        view.addSubview(signupButton)

        signupButton.snp.makeConstraints { make in
            make.top.equalTo(signinButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(50)
        }
    }
}

// MARK: Bindings
extension SigninViewController {
    private func setupBindings() {
        let enableButton = Observable
            .combineLatest(viewModel.outputs.isEmailValid, viewModel.outputs.isPasswordValid) {
                $0.isValid && $1.isValid
            }
            .share(replay: 1)

        enableButton
            .bind(to: signinButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty.distinctUntilChanged()
            .bind(onNext: viewModel.inputs.emailDidChange(email:))
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty.distinctUntilChanged()
            .bind(onNext: viewModel.inputs.passwordDidChange(password:))
            .disposed(by: disposeBag)
        
        signinButton.rx.tap.bind {
            self.viewModel.inputs.signinUser(email: self.emailTextField.text!, password: self.passwordTextField.text!.base64Encoded()!)
        }
        .disposed(by: disposeBag)
        
        signupButton.rx.tap.bind {
            self.viewModel.inputs.signupUser()
        }
        .disposed(by: disposeBag)
        
        viewModel.outputs.isEmailValid.map { $0.borderColor }
            .bind(to: emailTextField.rx.borderColor)
            .disposed(by: disposeBag)

        viewModel.outputs.isPasswordValid.map { $0.borderColor }
            .bind(to: passwordTextField.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.outputs.invalidEmailMessage
            .bind(to: emailErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.invalidPasswordMessage
            .bind(to: passwordErrorLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

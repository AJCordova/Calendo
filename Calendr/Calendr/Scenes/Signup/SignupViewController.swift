//
//  SignupViewController.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/11/22.
//

import Foundation
import UIKit
import RxSwift

class SignupViewController: UIViewController {
    
    private var viewModel: SignupViewModelTypes
    
    lazy var emailTextField: UITextField = UITextField()
    lazy var emailErrorLabel: UILabel = UILabel()
    lazy var passwordTextField: UITextField = UITextField()
    lazy var passwordErrorLabel: UILabel = UILabel()
    lazy var confirmPasswordTextField: UITextField = UITextField()
    lazy var confirmErrorLabel: UILabel = UILabel()
    lazy var signupButton: UIButton = UIButton()
    lazy var signinButton: UIButton = UIButton()
    lazy var disposeBag = DisposeBag()
    
    init(viewModel: SignupViewModelTypes) {
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

extension SignupViewController {
    func setupViews() {
        setupEmailTextField()
        setupEmailErrorLabel()
        setupPasswordTextField()
        setupPasswordErrorLabel()
        setupVerifyPasswordTextField()
        setupVerifyPasswordErrorLabel()
        setupRegisterButton()
        setupSigninButton()
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
    
    private func setupVerifyPasswordTextField() {
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.layer.borderColor = UIColor.systemGray3.cgColor
        confirmPasswordTextField.layer.borderWidth = 0.5
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.autocapitalizationType = .none
        view.addSubview(confirmPasswordTextField)
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.left.right.equalTo(passwordTextField)
            make.height.equalTo(50)
        }
    }
    
    private func setupVerifyPasswordErrorLabel() {
        confirmErrorLabel.textColor = .systemRed
        confirmErrorLabel.font = .systemFont(ofSize: 10)
        view.addSubview(confirmErrorLabel)
        
        confirmErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom)
            make.left.right.equalTo(confirmPasswordTextField)
        }
    }

    private func setupRegisterButton() {
        signupButton.backgroundColor = .systemBlue
        signupButton.setTitle("Sign up", for: .normal)
        signupButton.layer.cornerRadius = 9.0
        signupButton.isEnabled = false
        view.addSubview(signupButton)

        signupButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(50)
        }
    }
    
    private func setupSigninButton() {
        signinButton.backgroundColor = .systemBlue
        signinButton.setTitle("Sign in", for: .normal)
        signinButton.layer.cornerRadius = 9.0
        view.addSubview(signinButton)
        
        signinButton.snp.makeConstraints { make in
            make.top.equalTo(signupButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(50)
        }
    }
}

extension SignupViewController {
    func setupBindings() {
        let enableSignupButton = Observable
            .combineLatest(viewModel.outputs.isEmailValid, viewModel.outputs.isPasswordValid,
                           viewModel.outputs.doesPasswordMatch, viewModel.outputs.isEmailAvailable) {
                $0.isValid && $1.isValid && $2 && $3
            }
            .share(replay: 1)
        
        enableSignupButton
            .bind(to: signupButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty.distinctUntilChanged()
            .bind(onNext: viewModel.inputs.emailDidChange(email:))
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty.distinctUntilChanged()
            .bind(onNext: viewModel.inputs.passwordDidChange(password:))
            .disposed(by: disposeBag)
        
        confirmPasswordTextField.rx.text.orEmpty.distinctUntilChanged()
            .bind(onNext: { userInput in
                guard let passwordInput = self.passwordTextField.text else { return }
                if passwordInput.isEmpty {
                    return
                    
                } else {
                    self.viewModel.inputs.confirmPassDidChange(password: userInput, control: passwordInput)
                }
            })
            .disposed(by: disposeBag)
        
        signinButton.rx.tap.bind {
            self.viewModel.inputs.goToSignin()
        }
        .disposed(by: disposeBag)
        
        signupButton.rx.tap.bind { [self] in
            viewModel.inputs.submitRegistration(email: self.emailTextField.text!, hash: self.passwordTextField.text!.base64Encoded()!)
        }
        .disposed(by: disposeBag)
        
        viewModel.outputs.isEmailValid.map { $0.borderColor }
            .bind(to: emailTextField.rx.borderColor)
            .disposed(by: disposeBag)

        viewModel.outputs.isPasswordValid.map { $0.borderColor }
            .bind(to: passwordTextField.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.outputs.doesPasswordMatch
            .map { $0 == true ? UIColor.lightGray.cgColor : UIColor.systemRed.cgColor }
            .bind(to: confirmPasswordTextField.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.outputs.invalidEmailMessage
            .bind(to: emailErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.invalidPasswordMessage
            .bind(to: passwordErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.mismatchPasswordMessage
            .bind(to: confirmErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        //viewModel.outputs.isEmailAvailable
    }
}

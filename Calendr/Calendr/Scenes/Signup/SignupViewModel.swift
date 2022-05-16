//
//  SignupViewModel.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/10/22.
//

import RxSwift
import RxCocoa

protocol SignupViewModelInputs {
    func emailDidChange(email: String)
    func passwordDidChange(password: String)
    func confirmPassDidChange(password: String, control: String)
    func submitRegistration(email: String, hash: String)
    func goToSignin()
}

protocol SignupViewModelOutputs {
    var isEmailValid: PublishRelay<TextFieldStatus> { get }
    var isPasswordValid: PublishRelay<TextFieldStatus> { get }
    var doesPasswordMatch: PublishRelay<Bool> { get }
    var isEmailAvailable: PublishRelay<Bool> { get }
    var invalidEmailMessage: PublishRelay<String> { get }
    var invalidPasswordMessage: PublishRelay<String> { get }
    var mismatchPasswordMessage: PublishRelay<String> { get }
}

protocol SignupViewModelTypes {
    var inputs: SignupViewModelInputs { get }
    var outputs: SignupViewModelOutputs { get }
}

class SignupViewModel: SignupViewModelInputs, SignupViewModelOutputs, SignupViewModelTypes {
    var inputs: SignupViewModelInputs { return self }
    var outputs: SignupViewModelOutputs { return self }
    
    var isEmailValid: PublishRelay<TextFieldStatus> = PublishRelay()
    var isPasswordValid: PublishRelay<TextFieldStatus> = PublishRelay()
    var doesPasswordMatch: PublishRelay<Bool> = PublishRelay()
    var isEmailAvailable: PublishRelay<Bool> = PublishRelay()
    var invalidEmailMessage: PublishRelay<String> = PublishRelay()
    var invalidPasswordMessage: PublishRelay<String> = PublishRelay()
    var mismatchPasswordMessage: PublishRelay<String> = PublishRelay()
    
    private var disposeBag = DisposeBag()
    private var coordinator: SignupCoordinatorDelegate
    private var emailDidChangeProperty = PublishSubject<String>()
    private var passwordDidChangeProperty = PublishSubject<String>()
    private var verifyPassDidChangeProperty = PublishSubject<String>()
    private var userManager: UserManagementProtocol
    
    init(coordinate: SignupCoordinatorDelegate) {
        self.coordinator = coordinate
        self.userManager = UserManagementService()
        
        emailDidChangeProperty
            .map { $0.isValidEmail }
            .bind(to: isEmailValid)
            .disposed(by: disposeBag)
        
        emailDidChangeProperty
            .filter { $0.isValidEmail.isValid }
            .bind(onNext: { email in
                self.verifyEmailAvailability(email: email)
            })
            .disposed(by: disposeBag)
        
        isEmailValid
            .filter { $0 == .invalid }
            .map { _ in "Enter a valid email address."}
            .bind(to: invalidEmailMessage)
            .disposed(by: disposeBag)
        
        isEmailValid
            .filter { $0 == .valid }
            .map { _ in "" }
            .bind(to: invalidEmailMessage)
            .disposed(by: disposeBag)
        
        isEmailAvailable
            .filter { $0 == true }
            .map { _ in "" }
            .bind(to: invalidEmailMessage)
            .disposed(by: disposeBag)
        
        isEmailAvailable
            .filter { $0 == false }
            .map { _ in "This email account has been registered. Please use another." }
            .bind(to: invalidEmailMessage)
            .disposed(by: disposeBag)
            
        passwordDidChangeProperty
            .map { $0.count > 7 && $0.count < 21 ? .valid : .invalid }
            .bind(to: isPasswordValid)
            .disposed(by: disposeBag)
        
        isPasswordValid
            .filter { $0 == .invalid }
            .map { _ in "Password has to be from 8 to 20 characters long." }
            .bind(to: invalidPasswordMessage)
            .disposed(by: disposeBag)
        
        isPasswordValid
            .filter { $0 == .valid }
            .map { _ in "" }
            .bind(to: invalidPasswordMessage)
            .disposed(by: disposeBag)
        
        doesPasswordMatch
            .filter { $0 == false }
            .map { _ in "This must match with your password above." }
            .bind(to: mismatchPasswordMessage)
            .disposed(by: disposeBag)
        
        doesPasswordMatch
            .filter { $0 == true }
            .map { _ in "" }
            .bind(to: mismatchPasswordMessage)
            .disposed(by: disposeBag)
        
        userManager.isEmailAvailable
            .bind(to: isEmailAvailable)
            .disposed(by: disposeBag)
        
        userManager.isSignupSuccessful
            .filter { $0 == true }
            .bind(onNext: { _ in
                self.goToSignin()
            })
            .disposed(by: disposeBag)
    }
    
    func emailDidChange(email: String) {
        emailDidChangeProperty.onNext(email)
    }
    
    func passwordDidChange(password: String) {
        passwordDidChangeProperty.onNext(password)
    }
    
    func confirmPassDidChange(password: String, control: String) {
        if password.isEmpty {
            return
        } else if password.elementsEqual(control) {
            doesPasswordMatch.accept(true)
        } else {
            doesPasswordMatch.accept(false)
        }
    }
    
    func submitRegistration(email: String, hash: String) {
        userManager.userSignup(email: email, hash: hash)
    }
    
    func goToSignin() {
        coordinator.goToSignin()
    }
    
    private func verifyEmailAvailability(email: String) {
        userManager.checkIfEmailAvailable(email: email)
    }
}



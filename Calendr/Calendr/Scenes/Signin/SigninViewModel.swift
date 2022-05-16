//
//  SigninViewModel.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/10/22.
//

import RxSwift
import RxCocoa

protocol SigninViewModelInputs {
    func emailDidChange(email: String)
    func passwordDidChange(password: String)
    func signinUser(email: String, password: String)
    func signupUser()
}

protocol SigninViewModelOutputs {
    var isEmailValid: PublishRelay<TextFieldStatus> { get }
    var isPasswordValid: PublishRelay<TextFieldStatus> { get }
    var invalidEmailMessage: PublishRelay<String> { get }
    var invalidPasswordMessage: PublishRelay<String> { get }
}

protocol SigninViewModelTypes {
    var inputs: SigninViewModelInputs { get }
    var outputs: SigninViewModelOutputs { get }
}

class SigninViewModel: SigninViewModelInputs, SigninViewModelOutputs, SigninViewModelTypes {
    var inputs: SigninViewModelInputs { return self }
    var outputs: SigninViewModelOutputs { return self }
    
    var isEmailValid: PublishRelay<TextFieldStatus> = PublishRelay()
    var isPasswordValid: PublishRelay<TextFieldStatus> = PublishRelay()
    var invalidEmailMessage: PublishRelay<String> = PublishRelay()
    var invalidPasswordMessage: PublishRelay<String> = PublishRelay()
    
    private var disposeBag = DisposeBag()
    private var coordinator: SigninCoordinatorDelegate
    private var emailDidChangeProperty = PublishSubject<String>()
    private var passwordDidChangeProperty = PublishSubject<String>()
    private var shouldProceedToEvents = PublishSubject<Bool>()
    private var userManager: UserManagementProtocol
    
    init(coordinator: SigninCoordinatorDelegate) {
        self.coordinator = coordinator
        self.userManager = UserManagementService()
        
        emailDidChangeProperty
            .map { $0.isValidEmail }
            .bind(to: isEmailValid)
            .disposed(by: disposeBag)
        
        isEmailValid
            .filter { $0 == .invalid }
            .map { _ in "Please enter a valid email address." }
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
        
        isEmailValid
            .filter { $0 == .valid }
            .map { _ in "" }
            .bind(to: invalidEmailMessage)
            .disposed(by: disposeBag)
        
        isPasswordValid
            .filter { $0 == .valid }
            .map { _ in "" }
            .bind(to: invalidPasswordMessage)
            .disposed(by: disposeBag)
        
        userManager.isSigninValid
            .bind(to: shouldProceedToEvents)
            .disposed(by: disposeBag)
        
        shouldProceedToEvents
            .filter { $0 == true }
            .bind(onNext: { _ in
                self.coordinator.goToEvents()
            })
            .disposed(by: disposeBag)
    }
    
    func emailDidChange(email: String) {
        emailDidChangeProperty.onNext(email)
    }
    
    func passwordDidChange(password: String) {
        passwordDidChangeProperty.onNext(password)
    }
    
    func signinUser(email: String, password: String) {
        retrieveUser(email: email, password: password)
    }
    
    func signupUser() {
        coordinator.goToSignup()
    }
    
    private func retrieveUser(email: String, password: String) {
        userManager.userSignin(email: email, hash: password)
    }
}



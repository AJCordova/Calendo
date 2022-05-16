//
//  UserManagementProtocol.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/12/22.
//

import Foundation
import RxCocoa

protocol UserManagementProtocol {
    
    var isSigninValid: PublishRelay<Bool> { get }
    var errorMessage: PublishRelay<String> { get }
    var hasExitedPrematurely: PublishRelay<Bool> { get }
    func userSignin(email: String, hash: String)
    func getSavedUser() -> UserModel?

    var isSignupSuccessful: PublishRelay<Bool> { get }
    var isEmailAvailable: PublishRelay<Bool> { get }
    func checkIfEmailAvailable(email: String)
    func userSignup(email: String, hash: String)
}

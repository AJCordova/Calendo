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
    
    // TODO: Implement for the register feature
    /**
     var isUsernameAvailable: PublishRelay<Bool> { get }
     var isRegisterSuccessful: PublishRelay<Bool> { get }
     func checkUsernameAvailability(userInput: String)
     func registerNewUser(username: String, password: String)
     */
}

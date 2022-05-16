//
//  UserManagementService.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/12/22.
//

import Foundation
import RxCocoa
import KeychainSwift
import FirebaseFirestore


class UserManagementService: UserManagementProtocol {
    var isEmailAvailable: PublishRelay<Bool> = PublishRelay<Bool>()
    var isSigninValid = PublishRelay<Bool>()
    var hasExitedPrematurely = PublishRelay<Bool>()
    var errorMessage = PublishRelay<String>()
    var isSignupSuccessful = PublishRelay<Bool>()
    
    private static var db = Firestore.firestore()
    private var reference: CollectionReference? = db.collection(Constants.FirebaseStrings.userCollectionReference)
    private var docReference: DocumentReference? = nil
    
}

extension UserManagementService {
    
    func getSavedUser() -> UserModel? {
        if let userData = KeychainSwift().getData(Constants.Keys.userInfoKey),
           let user = try? JSONDecoder().decode(UserModel.self, from: userData) { return user }
        
        return nil
    }
    
    func userSignin(email: String, hash: String) {
        reference?.whereField(Constants.FirebaseStrings.userReference, isEqualTo: email)
            .getDocuments() { (snapshot, error) in
                if let err = error {
                    print("Error: \(err.localizedDescription)")
                    self.errorMessage.accept("Login Error")
                    self.hasExitedPrematurely.accept(true)
                } else {
                    if snapshot?.documents.count == 1 {
                        guard let document = snapshot?.documents.first else { return }
                        let data = document.data()
                        if hash.elementsEqual((data["password"] as? String)!) {
                            self.isSigninValid.accept(true)
                        } else {
                            self.isSigninValid.accept(false)
                        }
                    } else {
                        self.isSigninValid.accept(false)
                    }
                }
            }
    }
    
    func userSignup(email: String, hash: String) {
        docReference = reference?
            .addDocument(data: ["email": email, "password": hash]) { error in
                if let err = error {
                    print("Error: \(err.localizedDescription)")
                    self.errorMessage.accept("Register Error")
                    self.hasExitedPrematurely.accept(true)
                } else {
                    let userID = self.docReference?.documentID
                    guard userID != nil else {
                        self.isSignupSuccessful.accept(false)
                        return
                    }
                    self.isSignupSuccessful.accept(true)
                }
            }
    }
    
    func checkIfEmailAvailable(email: String) {
        reference?.whereField(Constants.FirebaseStrings.userReference, isEqualTo: email)
            .getDocuments() { (snapshot, error) in
                if let err = error {
                    print("Error: \(err)")
                    self.hasExitedPrematurely.accept(true)
                } else {
                    if snapshot!.isEmpty {
                        self.isEmailAvailable.accept(true)
                    } else {
                        self.isEmailAvailable.accept(false)
                    }
                }
            }
    }
}

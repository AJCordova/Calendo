//
//  SignupCoordinator.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/16/22.
//

import Foundation
import UIKit

protocol SignupCoordinatorDelegate: AnyObject {
    func goToSignin()
}

final class SignupCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SignupViewModel(coordinate: self)
        let viewController = SignupViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}

extension SignupCoordinator: SignupCoordinatorDelegate {
    func goToSignin() {
        let signinCoordinator = SigninCoordinator(navigationController: navigationController)
        coordinate(to: signinCoordinator)
    }
}

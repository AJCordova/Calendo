//
//  SigninCoordinator.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/12/22.
//

import Foundation
import UIKit

protocol SigninCoordinatorDelegate: AnyObject {
    func goToEvents()
}

final class SigninCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SigninViewModel()
        viewModel.coordinator = self
        let viewController = SigninViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: Nav controls
extension SigninCoordinator: SigninCoordinatorDelegate {
    func goToEvents() {
        let eventsCoordinator = EventsCoordinator(navigationController: navigationController)
        coordinate(to: eventsCoordinator)
    }
}

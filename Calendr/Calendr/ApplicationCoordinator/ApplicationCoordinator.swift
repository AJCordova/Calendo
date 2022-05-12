//
//  ApplicationCoordinator.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/10/22.
//

import UIKit

protocol Coordinator {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}

final class ApplicationCoordinator: Coordinator {
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let signinCoordinator = SigninCoordinator(navigationController: navigationController)
        coordinate(to: signinCoordinator)
    }
}

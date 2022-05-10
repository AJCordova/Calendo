//
//  ApplicationCoordinator.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/10/22.
//

import UIKit

protocol Coordinator {
    func start()
}

class ApplicationCoordinator: Coordinator {
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        //let viewModel = SigninViewModel()
        //let viewController = SigninViewController(viewModel: viewModel)
        let viewController = LoginViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}

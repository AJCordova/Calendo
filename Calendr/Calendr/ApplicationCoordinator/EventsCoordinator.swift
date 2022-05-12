//
//  EventsCoordinator.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/12/22.
//

import Foundation
import UIKit



final class EventsCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = EventsViewModel()
        let viewController = EventsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

//
//  EventsCoordinator.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/12/22.
//

import Foundation
import UIKit

protocol EventsCoordinatorDelegate: AnyObject {
}


final class EventsCoordinator: Coordinator, EventsCoordinatorDelegate {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = EventsViewModel(coordinator: self)
        let viewController = EventsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}


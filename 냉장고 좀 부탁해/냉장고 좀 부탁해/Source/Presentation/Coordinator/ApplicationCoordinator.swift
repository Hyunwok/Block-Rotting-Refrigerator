//
//  ApplicationCoordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/09.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    let nav: UINavigationController
    
    init(_ nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let coordinator: TabBarCoordinatorProtocol = AppDIContainer.shared.resolve()
        self.childCoordinator.append(coordinator)
        coordinator.start()
    }
}

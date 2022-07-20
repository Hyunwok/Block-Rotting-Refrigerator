//
//  Coordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/09.
//

import UIKit

protocol Coordinator: AnyObject {
    var rootViewController: UIViewController { get }
    var childCoordinator: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    func removeChild(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinator.enumerated() {
            if coordinator === child {
                childCoordinator.remove(at: index)
            }
        }
    }
}

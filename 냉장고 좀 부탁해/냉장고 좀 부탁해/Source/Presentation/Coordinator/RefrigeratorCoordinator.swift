//
//  RefrigeratorCoordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/18.
//

import UIKit

final class RefrigeratorCoordinator: Coordinator {
    var rootViewController: UIViewController {
        return RefrigeratorViewController()
    }
    
    var childCoordinator: [Coordinator] = []
    
    func start() {
        print("Asd")
    }
    
    
}

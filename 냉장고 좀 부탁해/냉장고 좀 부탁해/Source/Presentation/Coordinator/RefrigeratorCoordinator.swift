//
//  RefrigeratorCoordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/18.
//

import UIKit

protocol RefrigeratorCoordinatorProtocol: Coordinator {
    func addItem()
    func selectedItem(_ item: FoodItem)
}

final class RefrigeratorCoordinator: RefrigeratorCoordinatorProtocol {
    let nav: UINavigationController
    
    var childCoordinator: [Coordinator] = []
    
    init(_ nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {}
    
    func addItem() {
//        self.nav.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
    }
    
    func selectedItem(_ item: FoodItem) {
        print(":ASD")
    }
}

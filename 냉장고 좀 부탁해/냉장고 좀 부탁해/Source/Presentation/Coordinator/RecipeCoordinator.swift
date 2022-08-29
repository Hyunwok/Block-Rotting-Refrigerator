//
//  RecipeCoordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/18.
//

import UIKit
 
protocol RecipeCoordinatorProtocol: Coordinator {
    func moveToDetail(_ item: MealType)
}

final class RecipeCoordinator: RecipeCoordinatorProtocol {
    weak var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    let nav: UINavigationController
    
    init(_ nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        print("RecipeCoordinator Start")
    }
    
    func moveToDetail(_ item: MealType) {
        let vc: RecipeListViewController = AppDIContainer.shared.resolve()
        vc.category = item.description
        self.nav.pushViewController(vc, animated: true)
    }
}

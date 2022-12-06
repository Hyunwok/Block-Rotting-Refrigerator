//
//  RecipeCoordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/18.
//

import UIKit
import SafariServices
 
protocol RecipeCoordinatorProtocol: Coordinator {
    func moveToList(_ item: MealType)
    func moveToDetail(_ item: FoodDetailResponseDTO)
    func youtube(_ url: String?)
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
    
    func moveToList(_ item: MealType) {
        let vc: RecipeListViewController = AppDIContainer.shared.resolve()
        vc.category = item.rawValue
        self.nav.pushViewController(vc, animated: true)
    }
    
    func moveToDetail(_ item: FoodDetailResponseDTO) {
        let vc: RecipeInfoViewController = AppDIContainer.shared.resolve()
        vc.id = item.idMeal
        vc.name = item.strMeal
        self.nav.pushViewController(vc, animated: true)
    }
    
    func youtube(_ url: String?) {
        if let urlStr = url,
           let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

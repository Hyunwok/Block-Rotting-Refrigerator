//
//  RecipeCoordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/18.
//

import UIKit

final class RecipeCoordinator: Coordinator {
    var rootViewController: UIViewController {
        return RecipeViewController()
    }
    
    var childCoordinator: [Coordinator] = []
    
    func start() {
        print("Asd")
    }
    
    
}

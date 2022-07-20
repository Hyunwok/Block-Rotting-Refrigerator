//
//  SettingCoordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/18.
//

import UIKit

final class SettingCoordinator: Coordinator {
    var rootViewController: UIViewController {
        return SettingViewController()
    }
    
    var childCoordinator: [Coordinator] = []
    
    func start() {
        print("Asdas")
    }
    
    
}

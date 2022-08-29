//
//  SettingCoordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/18.
//

import UIKit

final class SettingCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinator: [Coordinator] = []
    let nav: UINavigationController
    
    init(_ nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        print("SettingCoordinator Start")
    }
    
    
}

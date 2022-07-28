//
//  AppAssembly.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/27.
//

import Foundation

import Swinject

final class AppAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FoodsRepository.self) { _ in RealmFoodStorage() }
        
        container.register(UINavigationController.self, name: "Base") { _ in
            let nav = UINavigationController()
            nav.setNavigationBarHidden(true, animated: false)
            return nav
        }.inObjectScope(.container)
        
        container.register(Coordinator.self) { resolver in
            guard let nav = resolver.resolve(UINavigationController.self, name: "Base") else {
                fatalError("Can't resolve nav from container in AppAssembly")
            }
            return ApplicationCoordinator(nav)
        }
    }
}

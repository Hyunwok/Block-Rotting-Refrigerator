//
//  TabAssembly.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/27.
//

import Foundation

import Swinject

final class TabAssembly: Assembly {
    func assemble(container: Container) {
        base(container)
        refriger(container)
        recipe(container)
        setting(container)
    }
    
    func base(_ container: Container) {
        container.register(TabBarCoordinatorProtocol.self) { resolver in
            guard let nav = resolver.resolve(UINavigationController.self, name: "Base") else {
                fatalError("Can't resolve nav from container in TabAssembly")
            }
            return TabCoordinator(nav)
        }
    }
    
    func refriger(_ container: Container) {
        container.register(UINavigationController.self, name: TabBarPage.refrigerator.pageTitleValue()) { _ in UINavigationController() }
        
        container.register(RefrigeratorCoordinatorProtocol.self) { resolver in
            guard let nav = resolver.resolve(UINavigationController.self, name: TabBarPage.refrigerator.pageTitleValue()) else {
                fatalError("Can't resolve nav from TabAssembly - refriger")
            }
            
            return RefrigeratorCoordinator(nav)
        }
        
        container.register(RefrigeratorReactor.self) { resolver in
            guard let coordi = resolver.resolve(RefrigeratorCoordinatorProtocol.self),
                  let provider = resolver.resolve(FoodsRepository.self) else {
                fatalError()
            }
            return RefrigeratorReactor(coordi, provider)
        }
        
        container.register(RefrigeratorViewController.self) { resolver in
            guard let reactor = resolver.resolve(RefrigeratorReactor.self) else {
                fatalError()
            }
            return RefrigeratorViewController(reactor)
        }
    }
    
    func recipe(_ container: Container) {
        container.register(UINavigationController.self, name: TabBarPage.recipe.pageTitleValue()) { _ in UINavigationController() }
    }
    
    func setting(_ container: Container) {
        container.register(UINavigationController.self, name: TabBarPage.setting.pageTitleValue()) { _ in UINavigationController() }
    }
}

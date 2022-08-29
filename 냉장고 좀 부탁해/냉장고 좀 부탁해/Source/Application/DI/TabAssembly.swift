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
        container.register(UINavigationController.self, name: TabBarPage.refrigerator.pageTitleValue()) { _ in
            let nav = UINavigationController()
            nav.setNavigationBarHidden(true, animated: false)
            return nav
        }.inObjectScope(.container)
        
        
        container.register(RefrigeratorCoordinatorProtocol.self) { resolver in
            guard let nav = resolver.resolve(UINavigationController.self, name: TabBarPage.refrigerator.pageTitleValue()) else {
                fatalError("Can't resolve nav from TabAssembly - refriger")
            }
            
            return RefrigeratorCoordinator(nav)
        }
        
        container.register(RefrigeratorReactor.self) { resolver in
            guard let coordi = resolver.resolve(RefrigeratorCoordinatorProtocol.self),
                  let repo = resolver.resolve(FoodsRepository.self, name: "Realm") else {
                fatalError()
            }
            return RefrigeratorReactor(coordi, repo)
        }
        
        container.register(RefrigeratorViewController.self) { resolver in
            guard let reactor = resolver.resolve(RefrigeratorReactor.self) else {
                fatalError()
            }
            return RefrigeratorViewController(reactor)
        }
    }
    
    func recipe(_ container: Container) {
        container.register(UINavigationController.self, name: TabBarPage.recipe.pageTitleValue()) { _ in UINavigationController() }.inObjectScope(.container)
        
        container.register(RecipeCoordinatorProtocol.self) { resolver in
            guard let nav = resolver.resolve(UINavigationController.self, name: TabBarPage.recipe.pageTitleValue()) else {
                fatalError("Can't resolve nav from TabAssembly - recipe")
            }
            
            return RecipeCoordinator(nav)
        }
        
        container.register(RecipeReactor.self) { resolver in
            guard let coor: RecipeCoordinatorProtocol = resolver.resolve(RecipeCoordinatorProtocol.self),
            let dataTransfer = resolver.resolve(DataTransferService.self) else { fatalError() }
            return RecipeReactor(coor, dataTransfer)
        }
        
        container.register(RecipeCategoryViewController.self) { resolver in
            guard let reactor: RecipeReactor = resolver.resolve(RecipeReactor.self) else { fatalError() }
            return RecipeCategoryViewController(reactor)
        }
    }
    
    func setting(_ container: Container) {
        container.register(UINavigationController.self, name: TabBarPage.setting.pageTitleValue()) { _ in UINavigationController() }.inObjectScope(.container)
    }
}

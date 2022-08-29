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
        container.register(FoodsRepository.self, name: "Realm") { _ in RealmFoodStorage() }
        
        container.register(NetworkConfigurable.self, name: "themealdb") { _ in
            guard let url = URL(string: "www.themealdb.com/") else { fatalError() }
            return ApiDataNetworkConfig(baseURL: url)
        }
        
        container.register(NetworkService.self) { resolver in
            guard let config = resolver.resolve(NetworkConfigurable.self, name: "themealdb") else { fatalError() }
            return DefaultNetworkService(config: config)
        }
        
        container.register(DataTransferService.self) { resolver in
            guard let service = resolver.resolve(NetworkService.self) else { fatalError() }
            return DefaultDataTransferService(with: service)
        }
        
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

//
//  RecipeAssembly.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/25.
//

import Foundation

import Swinject

final class RecipeAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RecipeListReactor.self) { resolver in
            guard let dataTransfer = resolver.resolve(Provider.self) else { fatalError() }
            
            return RecipeListReactor(dataTransfer)
        }
        
        container.register(RecipeListViewController.self) { resolver in
            guard let reactor = resolver.resolve(RecipeListReactor.self),
                  let coor: RecipeCoordinatorProtocol = resolver.resolve(RecipeCoordinatorProtocol.self) else { fatalError() }
            
            return RecipeListViewController(reactor, coor)
        }
        
        container.register(RecipeInfoReactor.self) { resolver in
            guard let dataTransfer = resolver.resolve(Provider.self) else { fatalError() }
            
            return RecipeInfoReactor(dataTransfer)
        }
        
        container.register(RecipeInfoViewController.self) { resolver in
            guard let reactor = resolver.resolve(RecipeInfoReactor.self),
                  let coor: RecipeCoordinatorProtocol = resolver.resolve(RecipeCoordinatorProtocol.self) else { fatalError() }
            
            return RecipeInfoViewController(reactor, coor)
        }
    }
}

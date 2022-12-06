//
//  RefrigerAssembly.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/02.
//

import Foundation
import PhotosUI

import Swinject

class RefrigerAssembly: Assembly {
    func assemble(container: Container) {
        registerAddItem(container)
        registerEditItem(container)
    }
    
    private func registerAddItem(_ container: Container) {
        container.register(AddItemCoordinatorProtocol.self) { resolver in
            guard let nav = resolver.resolve(UINavigationController.self, name: "Base"),
                  let parentCoordinator = resolver.resolve(RefrigeratorCoordinatorProtocol.self) else {
                fatalError("Can't resolve nav from container in TabAssembly")
            }
            
            let coordinator = AddItemCoordinator(nav)
            coordinator.parentCoordinator = parentCoordinator
            return coordinator
        }//.inObjectScope(.container)
        
        container.register(AddItemReactor.self) { resolver in
            guard let repo = resolver.resolve(FoodItemStorage.self, name: "RealmFoodItemStorage"),
                  let alert = resolver.resolve(AlertServiceType.self) else { fatalError() }
            return AddItemReactor(repo, alertService: alert)
        }//.inObjectScope(.graph)
        
        container.register(AddItemViewController.self) { resolver in
            guard let reactor = resolver.resolve(AddItemReactor.self),
                  let coordi = resolver.resolve(AddItemCoordinatorProtocol.self) else {
                fatalError()
            }
            
            return AddItemViewController(reactor, coordi)
        }.inObjectScope(.graph)
        
        container.register(PHPickerViewController.self, name: "OneImage") { _ in
            var conf = PHPickerConfiguration()
            conf.selectionLimit = 1
            conf.filter = .images
            return PHPickerViewController(configuration: conf)
        }//.inObjectScope(.container)
        
        container.register(UIImagePickerController.self, name: "camera") { _ in
            let camera = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                camera.sourceType = .camera
                camera.allowsEditing = true
                camera.cameraDevice = .rear
                camera.cameraCaptureMode = .photo
            }
            return camera
        }//.inObjectScope(.container)
    }
    
    private func registerEditItem(_ container: Container) {
        container.register(EditCoordinatorBase.self) { resolver in
            guard let nav = resolver.resolve(UINavigationController.self, name: "Base"),
                  let parentCoordinator = resolver.resolve(RefrigeratorCoordinatorProtocol.self) else { fatalError() }
            let coor = EditCoordinator(nav: nav)
            coor.parentCoordinator = parentCoordinator
            return coor
        }
        
        container.register(EditReactor.self) { resolver in
            guard let alert = resolver.resolve(AlertServiceType.self),
                  let storage = resolver.resolve(FoodItemStorage.self, name: "RealmFoodItemStorage") else { fatalError() }
            
            return EditReactor(storage, alert)
        }
        
        container.register(EditViewController.self) { resolver in
            guard let reactor = resolver.resolve(EditReactor.self) else { fatalError() }
            return EditViewController(reactor)
        }
    }
}

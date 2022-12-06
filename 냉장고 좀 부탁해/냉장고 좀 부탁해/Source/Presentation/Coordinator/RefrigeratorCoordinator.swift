//
//  RefrigeratorCoordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/18.
//

import UIKit

import RxSwift

protocol RefrigeratorCoordinatorProtocol: Coordinator {
    func addItem()
    func selectedItem(_ item: FoodItem)
    func addAlert(_ alert: UIAlertController)
    func show<Action: AlertActionType>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [Action]
    ) -> Observable<Action>
}

final class RefrigeratorCoordinator: RefrigeratorCoordinatorProtocol {
    weak var parentCoordinator: Coordinator?
    
    let nav: UINavigationController
    
    var childCoordinator: [Coordinator] = []
    
    init(_ nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {}
    
    func addItem() {
        let coordinator: AddItemCoordinatorProtocol = AppDIContainer.shared.resolve()
        coordinator.parentCoordinator = self
        self.childCoordinator.append(coordinator)
        coordinator.start()
    }
    
    func selectedItem(_ item: FoodItem) {
        let coordinator: EditCoordinatorBase = AppDIContainer.shared.resolve()
        coordinator.food = item
        self.childCoordinator.append(coordinator)
        coordinator.start()
    }
    
    func addAlert(_ alert: UIAlertController) {
        nav.present(alert, animated: true)
    }
    
    func show<Action: AlertActionType>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [Action]
    ) -> Observable<Action> {
        return Observable.create { observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            for action in actions {
                let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action)
                    observer.onCompleted()
                }
                alert.addAction(alertAction)
            }
            self.nav.present(alert, animated: true)
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

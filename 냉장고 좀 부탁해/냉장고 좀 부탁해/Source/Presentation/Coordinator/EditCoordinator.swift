//
//  EditCoordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/24.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit

protocol EditCoordinatorBase: Coordinator {
    var food: FoodSection! { get set }
    
    func pop()
    func show<Action: AlertActionType>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [Action]
    ) -> Observable<Action>
}

final class EditCoordinator: NSObject, EditCoordinatorBase {
    var food: FoodSection!
    
    let nav: UINavigationController
    var childCoordinator: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc: EditViewController = AppDIContainer.shared.resolve()
        vc.modalPresentationStyle = .fullScreen
        vc.food = food
        nav.present(vc, animated: true)
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
            self.nav.presentedViewController?.present(alert, animated: true)
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func pop() {
        self.nav.dismiss(animated: true)
        self.parentCoordinator?.removeChild(self)
    }
}

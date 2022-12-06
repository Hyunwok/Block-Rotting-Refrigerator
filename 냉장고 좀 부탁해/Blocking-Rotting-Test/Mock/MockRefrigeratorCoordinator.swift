//
//  MockRefrigeratorCoordinator.swift
//  Blocking-Rotting-Test
//
//  Created by 이현욱 on 2022/09/15.
//

import UIKit
import RxSwift
@testable import 냉장고_좀_부탁해

class MockRefrigeratorCoordinator: RefrigeratorCoordinatorProtocol {
    func selectedItem(_ item: FoodItem) {
        print("selectedItem")
    }
    
    var selectAction: AlertActionType?
    
    func addItem() {
        print("addItem")
    }

    func addAlert(_ alert: UIAlertController) {
        print("addAlert")
    }

    func show<Action>(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [Action]) -> Observable<Action> where Action : AlertActionType {
        guard let selectAction = self.selectAction as? Action else {
            return .empty() }
        return .just(selectAction)

    }

    var childCoordinator: [Coordinator] = []

    var parentCoordinator: Coordinator?

    func start() {
        print("실행")
    }
}

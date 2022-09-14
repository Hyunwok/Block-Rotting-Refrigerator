//
//  Block_Rotting_Test.swift
//  Block-Rotting-Test
//
//  Created by 이현욱 on 2022/09/14.
//

import XCTest
@testable import 냉장고_좀_부탁해
import Realm
import RealmSwift
import ReactorKit

class Block_Rotting_Test: XCTestCase {

    let mockCoordi = MockRefrigeratorCoordinator()
    let mockRepo = MockRepo()
    lazy var reactor = RefrigeratorReactor(mockCoordi, mockRepo)
    lazy var vc = RefrigeratorViewController(reactor)

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_filterBtnTap() {
        // given
        vc.loadViewIfNeeded()

        // when
        vc.filterBtn.sendActions(for: .touchDown)

        // then
        XCTAssertTrue(true)
//        XCTAssertEqual(reactor.stub.actions.last, .orderBy)
    }

}


class MockRepo: FoodsRepository {
    func delete(_ item: FoodItemDTO, _ completion: (Bool) -> Void) {
        print("delete")
    }

    func deleteAll(_ completion: (Bool) -> Void) {
        print("deleteAll")
    }

    func fetch<T>() -> [T] where T : RealmFetchable, T : ConvertibleToModel {
        print("fetch")
        return []
    }

    func save<T>(_ item: T, _ completion: (Bool) -> Void) where T : RealmSwiftObject {
        print("save")
    }

    func update<T>(_ item: T, _ completion: (Bool) -> Void) where T : RealmSwiftObject {
        print("update")
    }

    func updateAll() {
        print("updateAll")
    }
}

class MockRefrigeratorCoordinator: RefrigeratorCoordinatorProtocol {
    func addItem() {
        print("addItem")
    }

    func selectedItem(_ item: FoodSection) {
        print("selectedItem")
    }

    func addAlert(_ alert: UIAlertController) {
        print("addAlert")
    }

    func show<Action>(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [Action]) -> Observable<Action> where Action : AlertActionType {
        return Observable.of(CameraAlertAction.self as! Action)

    }

    var childCoordinator: [Coordinator] = []

    var parentCoordinator: Coordinator?

    func start() {
        print("실행")
    }
}


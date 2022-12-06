//
//  MockAlertService.swift
//  Blocking-Rotting-Test
//
//  Created by 이현욱 on 2022/10/05.
//

import UIKit
@testable import 냉장고_좀_부탁해

import RxSwift

class MockAlertService: AlertServiceType {
    
    var selectAction: AlertActionType?
    
    func show<Action: AlertActionType>(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [Action]) -> Observable<Action> {
        guard let selectAction = self.selectAction as? Action else { return .empty() }
        return .just(selectAction)
    }
    
    
}

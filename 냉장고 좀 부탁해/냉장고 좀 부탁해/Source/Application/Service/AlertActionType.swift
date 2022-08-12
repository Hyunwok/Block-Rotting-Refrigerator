//
//  AlertActionType.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/11.
//

import Foundation

import RxSwift

protocol AlertActionType {
    var title: String? { get }
    var style: UIAlertAction.Style { get }
}

protocol AlertServiceType: AnyObject {
    func show<Action: AlertActionType>(
        coordinator: Coordinator & Coordinator,
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [Action]
    ) -> Observable<Action>
}

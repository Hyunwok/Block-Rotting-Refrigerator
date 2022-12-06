//
//  EditReactor.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/23.
//

import Foundation

import ReactorKit

let imageEvent = PublishSubject<UIImage>()

final class EditReactor: Reactor {
    var initialState = State()
    let alertService: AlertServiceType
    let storage: FoodItemStorage
    
    enum Action {
        case edit((FoodItem?, Bool))
        case delete(FoodItem)
        case close(Bool)
        case none
    }
    
    struct State {
        var image: UIImage?
        var dismiss = false
    }
    
    enum Mutation {
        case update(FoodItem)
        case delete(FoodItem)
        case dismissing
    }
    
    init(_ storage: FoodItemStorage, _ alertService: AlertServiceType) {
        self.storage = storage
        self.alertService = alertService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .close(let alertShow):
            if alertShow {
                let alertActions: [DismissAlertAction] = [.continue, .cancel]
                
                return alertService.show(title: "정말로 나가시겠어요?",
                                         message: "수정하려던 재료의 정보는 삭제될거에요.",
                                         preferredStyle: .alert, actions: alertActions)
                .flatMap { action -> Observable<Mutation> in
                    switch action {
                    case .continue:
                        return .empty()
                    case .cancel:
                        return .just(.dismissing)
                    }
                }
            } else {
                return .just(.dismissing)
            }
        case .delete(let food):
            let actions: [YesOrNoAlertAction] = [.yes, .no]
            
            return alertService.show(title: "재료를 삭제하시겠습니까?",
                                     message: nil,
                                     preferredStyle: .alert,
                                     actions: actions)
            .flatMap { alertAction -> Observable<Mutation> in
                switch alertAction {
                case .yes:
                    return .just(.delete(food))
                    
                case .no:
                    return .empty()
                }
            }
            
        case .edit(let food):
            if food.0 == nil { return .empty() }
            if food.1 {
                return .just(.dismissing)
            } else if  food.0!.number == 0 {
                return .just(.delete(food.0!))
            } else {
                return .just(.update(food.0!))
            }
        case .none:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .delete(food):
            self.storage.deleteItem(food) { bool in
                if bool {
                    NotiCenter.shared.deleteNoti(with: food)
                    newState.dismiss = !newState.dismiss
                } else {
                    self.failToRemoveAlert("삭제에 실패했습니다.")
                }
            }
        case let .update(food):
            self.storage.updateItem(food) { bool in
                if bool {
                    NotiCenter.shared.updateNoti(with: food)
                    newState.dismiss = !newState.dismiss
                } else {
                    failToRemoveAlert("수정에 실패했습니다.")
                }
            }
            
        case .dismissing:
            newState.dismiss = !newState.dismiss
        }
        
        return newState
    }
    
    private func failToRemoveAlert(_ title: String) {
        _ = alertService.show(title: title, message: nil, preferredStyle: .alert, actions: [OkAlertAction.ok])
            .flatMap { alertAction -> Observable<Action> in
                switch alertAction {
                case .ok:
                    return .just(.none)
                }
            }
    }
}

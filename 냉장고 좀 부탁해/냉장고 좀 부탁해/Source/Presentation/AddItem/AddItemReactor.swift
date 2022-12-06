//
//  AddItemReactor.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/02.
//

import Foundation

import ReactorKit
import RxSwift

enum FoodEvent {
    case updateImage(UIImage)
    case foodName(String)
    case foodPlace(ItemPlace)
    case remainDay(Int)
    case foodCnt(Int)
    case addType(FoodType)
}

let event = PublishSubject<FoodEvent>()

final class AddItemReactor: Reactor {
    private let storage: FoodItemStorage
    private let alertService: AlertServiceType
    
    var initialState = State()
    let subReactors: SubReactors
    
    enum Action {
        case addingImage
        case dismiss
        case add
        case foodName(String)
        case remainDay(Int)
    }
    
    struct State {
        var dismiss = false
        var cameraSelected = false
        var albumSelected = false
        var isAdding = true
        var food: FoodItem = FoodItem(name: "", remainingDay: 0, number: 0, itemImage: nil, itemPlace: .frozenTem, foodType: .cereals)
    }
    
    enum Mutation {
        case album
        case dismiss
        case adding
        case cameraing
        case addPlace(ItemPlace)
        case addFoodsCount(Int)
        case addFoodName(String)
        case addRemainDay(Int)
        case addImage(UIImage)
        case addType(FoodType)
    }
    
    struct SubReactors {
        let addNameAndIamgeReactor: AddNameAndImageReactor
        let remainDayReactor: RemainDayReactor
    }
    
    init( _ storage: FoodItemStorage, alertService: AlertServiceType) {
        self.storage = storage
        self.alertService = alertService
        self.subReactors = SubReactors(addNameAndIamgeReactor: AddNameAndImageReactor(),
                                       remainDayReactor: RemainDayReactor())
    }
    
    deinit {
        print("AddItem Deinited")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .add:
            return .just(.adding)
        case .addingImage:
            let action: [CameraAlertAction] = [.camera, .upload, .cancel]
            
            return alertService.show(title: "사진을 선택하세요",
                                         message: nil,
                                         preferredStyle: .actionSheet,
                                         actions: action)
            .flatMap { action -> Observable<Mutation> in
                switch action {
                case .camera:
                    return .just(.cameraing)
                case .upload:
                    return .just(.album)
                case .cancel:
                    return .empty()
                }
            }
        case .dismiss:
            if currentState.food.name != "" || currentState.food.itemImage != nil {
                let action: [DismissAlertAction] = [.continue, .cancel]
                
                return alertService.show(title: "정말로 나가시겠어요?",
                                             message: "추가하려던 재료의 정보는 삭제될거에요.",
                                             preferredStyle: .alert, actions: action)
                .flatMap { action -> Observable<Mutation> in
                    switch action {
                    case .continue:
                        return .empty()
                    case .cancel:
                        return .just(.dismiss)
                    }
                }
            }
            return .just(.dismiss)
        case .foodName(let text):
            return .just(.addFoodName(text))
        case .remainDay(let day):
            return .just(.addRemainDay(day))
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .foodName(let name):
                return .just(.addFoodName(name))
            case .foodPlace(let place):
                return .just(.addPlace(place))
            case .foodCnt(let cnt):
                return .just(.addFoodsCount(cnt))
            case .remainDay(let day):
                return .just(.addRemainDay(day))
            case .updateImage(let image):
                return .just(.addImage(image))
            case .addType(let type):
                return .just(.addType(type))
            }
        }
        return Observable.merge(mutation, eventMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .adding:
            newState.isAdding = true
            storage.saveItem(currentState.food) { _ in
                NotiCenter.shared.addNoti(with: self.currentState.food)
                newState.isAdding = false
            }
            newState.dismiss.toggle()
        case .cameraing:
            newState.cameraSelected.toggle()
        case .addPlace(let place):
            newState.food.itemPlace = place
        case .addFoodName(let name):
            newState.food.name = name
        case .addFoodsCount(let cnt):
            newState.food.number = cnt
        case .addImage(let image):
            newState.food.itemImage = image
        case .addRemainDay(let day):
            newState.food.remainingDay = day
        case .addType(let type):
            newState.food.foodType = type
        case .dismiss:
            newState.dismiss.toggle()
        case .album:
            newState.albumSelected.toggle()
        }
        return newState
    }
}

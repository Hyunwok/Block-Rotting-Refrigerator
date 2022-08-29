//
//  AddItemReactor.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/02.
//

import Foundation

import ReactorKit
import RxSwift

//  추가 후 메인 뷰 변경 확인
// 2번쨰 탭 이미지 추가ㅣ

final class AddItemReactor: Reactor {
    var initialState = State()
    private var coordinator: AddItemCoordinatorProtocol
    private let repo: FoodsRepository
    
    enum Action {
        case addingImage
        case dismiss
        case add
    }
    
    struct State {
        var isAdding = true
        var type: FoodType = .cereals
        var food: FoodItem = FoodItem(name: "", remainingDay: 0, number: 0, itemImage: nil, itemPlace: .frozenTem)
    }
    
    enum Mutation {
        case dismiss
        case adding
        case nothing
        case cameraing
        case addPlace(ItemPlace)
        case addFoodsCount(Int)
        case addFoodName(String)
        case addRemainDay(Int)
        case addImage(UIImage)
        case addType(FoodType)
    }
    
    init(_ coordinator: AddItemCoordinatorProtocol, _ repo: FoodsRepository) {
        self.coordinator = coordinator
        self.repo = repo
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
            
            return self.coordinator.show(title: "사진을 선택하세요",
                                         message: nil,
                                         preferredStyle: .actionSheet,
                                         actions: action)
            .flatMap { action -> Observable<Mutation> in
                switch action {
                case .camera:
                    self.coordinator.camera()
                    return .just(.cameraing)
                case .upload:
                    self.coordinator.imagePicker()
                    return .just(.cameraing)
                case .cancel:
                    return .just(.cameraing)
                }
            }
        case .dismiss:
            if currentState.food.name != "" || currentState.food.itemImage != nil {
                let action: [DismissAlertAction] = [.continue, .cancel]
                
                return self.coordinator.show(title: "정말로 나가시겠어요?",
                                             message: "추가하려던 재료의 정보는 삭제될거에요.",
                                             preferredStyle: .alert, actions: action)
                .flatMap { action -> Observable<Mutation> in
                    switch action {
                    case .continue:
                        return .just(.nothing)
                    case .cancel:
                        
                        self.coordinator.pop()
                        return .just(.dismiss)
                    }
                }
            }
            self.coordinator.pop()
            return .just(.dismiss)
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
            repo.save(FoodSection(type: currentState.type, items: [currentState.food]).toRealmObject()) { _ in
                newState.isAdding = false
                self.coordinator.pop()
            }
        case .cameraing:
            break
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
            newState.type = type
        case .dismiss:
            break
        case .nothing:
            print("dismiss")
        }
        
        return newState
    }
}

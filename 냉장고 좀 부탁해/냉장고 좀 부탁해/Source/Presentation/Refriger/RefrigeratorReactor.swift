//
//  RefrigeratorReactor.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/21.
//

import Foundation

import ReactorKit

typealias Foods = [FoodSection]

final class RefrigeratorReactor: Reactor {
    enum OrderType {
        case lessDay
        case manyDay
        case frozen
        case roomTem
        case coldTem
        case none
    }
    
    enum Action {
        case load
        case orderBy(OrderType)
        case itemSelect(FoodItem)
        case search(String)
        case addItem
    }
    
    enum Mutation {
        case currentFoods(Foods)
        case move
    }
    
    struct State {
        var orderBy: OrderType = .none
        var isHiddenSection: Bool = false
        var foods: Foods
    }
    
    var initialState = State(foods: [])
    private let coordinator: RefrigeratorCoordinatorProtocol
    private let provider: FoodsRepository
    
    init(_ coordinator: RefrigeratorCoordinatorProtocol, _ provider: FoodsRepository) {
        self.coordinator = coordinator
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .itemSelect(let foodItem):
            self.coordinator.selectedItem(foodItem)
            return .just(.move)
        case .addItem:
            self.coordinator.addItem()
            return .just(.move)
        case .load:
            print("??")
            let section = FoodSectionDAO()
            let item = FoodItemDAO()
            item.itemImageName = ""
            item.itemPlace = 2
            item.remainingDay = 1
            item.number = 1
            item.name = "양파"
            section.tabTypeEnum = .sideDish
            section.items.append(item) 
            provider.save([section])
            let foods = provider.fetch()
            let sortedFoods = foods.map { $0.toModel() }.sorted { $0.type.rawValue < $1.type.rawValue }
            return .just(.currentFoods(sortedFoods))
        case .search(let string):
            var items = [FoodItem]()
            for food in initialState.foods {
                items += food.items
            }
            
            let filteredItems = items.filter {
                if SearchingText.shared.isChosung(word: string) {
                    return $0.name.contains(string) || SearchingText.shared.chosungCheck(word: $0.name).contains(string)
                } else {
                    return $0.name.contains(string)
                }
            }
            
            return .just(.currentFoods([FoodSection(type: .none, items: filteredItems)]))
            
        case .orderBy(let orderType):
            var items = [FoodItem]()
            for food in initialState.foods {
                items += food.items
            }
            
            switch orderType {
            case .coldTem:
                items = items.filter { $0.itemPlace == .coldTem }
            case .frozen:
                items = items.filter { $0.itemPlace == .frozenTem }
            case .lessDay:
                items = items.sorted { $0.remainingDay < $1.remainingDay }
            case .manyDay:
                items = items.sorted { $0.remainingDay > $1.remainingDay }
            case .roomTem:
                items = items.filter { $0.itemPlace == .roomTem }
            default:
                print("none")
            }
            
            return .just(.currentFoods([FoodSection(type: .none, items: items)]))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .currentFoods(let foods):
            newState.isHiddenSection = foods.first?.type == TabType.none ? true : false
            newState.foods = foods
        case .move:
            print("moved")
        }
        return newState
    }
}

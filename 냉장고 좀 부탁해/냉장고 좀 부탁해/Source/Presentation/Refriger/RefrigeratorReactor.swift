//
//  RefrigeratorReactor.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/21.
//

import Foundation

import ReactorKit
import Differentiator
import RxDataSources

protocol ServiceProviderType: AnyObject {
    var alertService: AlertServiceType { get }
    var repo: FoodsRepository { get }
}

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
        case orderBy
        case itemSelect(FoodSection)
        case search(String?)
        case addItem
    }
    
    enum Mutation {
        case fetch([FoodSection])
        case currentFoods([FoodSection])
        case move
        case filter([FoodItem])
        case removeFilter([FoodSection])
    }
    
    struct State {
        var isOrdered: Bool = false
        var isHiddenSection: Bool = false
        var currentFoods = [FoodSection]()
        var fetchedFood = [FoodSection]()
    }
    
    private let repo: FoodsRepository
    private var filterFoods: [FoodSection] = []
    var initialState = State()
    private let coordinator: RefrigeratorCoordinatorProtocol
    
    init(_ coordinator: RefrigeratorCoordinatorProtocol, _ repo: FoodsRepository) {
        self.coordinator = coordinator
        self.repo = repo
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
            let foods: [FoodSectionDTO] = repo.fetch()
            return .just(.fetch(filtering(foods.map { $0.toModel() })))
            
        case .search(let string):
            if string != "", let text = string {
                var items: [FoodItem] = []
                
                for section in currentState.fetchedFood {
                    items += section.items
                }
                
                let filteredItems = items.filter {
                    if SearchingText.shared.isChosung(word: text) {
                        return $0.name.contains(text) || SearchingText.shared.chosungCheck(word: $0.name).contains(text)
                    } else {
                        return $0.name.contains(text)
                    }
                }
                return .just(.filter(filteredItems))
            } else {
                return .just(.removeFilter(currentState.fetchedFood))
            }
            
        case .orderBy:
            let alertActions: [FoodSortAlertAction] = [.frozen, .roomTem, .coldTem, .moreDay, .lessDay, .cancel]
            
            return self.coordinator.show(
                title: "필터링 종류",
                message: nil,
                preferredStyle: .actionSheet,
                actions: alertActions
            )
            .flatMap { alertAction -> Observable<Mutation> in
                var items: [FoodItem] = []
                let sec = self.currentState.isOrdered ? self.filterFoods : self.currentState.fetchedFood
                for section in sec {
                    items += section.items
                }
                
                switch alertAction {
                case .coldTem:
                    return .just(.currentFoods([FoodSection(type: .none, items: items.filter { $0.itemPlace == .coldTem })]))
                case .frozen:
                    return .just(.currentFoods([FoodSection(type: .none, items: items.filter { $0.itemPlace == .frozenTem })]))
                case .lessDay:
                    return .just(.currentFoods([FoodSection(type: .none,
                                                            items: items.sorted { $0.remainingDay < $1.remainingDay })]))
                case .moreDay:
                    return .just(.currentFoods([FoodSection(type: .none,
                                                            items: items.sorted { $0.remainingDay > $1.remainingDay })]))
                case .roomTem:
                    return .just(.currentFoods([FoodSection(type: .none, items: items.filter { $0.itemPlace == .roomTem })]))
                case .cancel:
                    // 만약 검색값이 있다면 filtered 를 보여줘야댐
                    if self.currentState.isOrdered {
                        return .just(.currentFoods(self.filterFoods))
                    } else {
                        return .just(.currentFoods(self.currentState.fetchedFood))
                    }
                }
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .currentFoods(let foods):
            newState.isHiddenSection = foods.first?.type == FoodType.none ? true : false
            newState.currentFoods = foods
        case .move:
            print("moved")
        case .fetch(let foods):
            newState.fetchedFood = foods
            newState.currentFoods = foods
        case .filter(let foods):
            newState.isOrdered = true
            newState.isHiddenSection = true
            self.filterFoods = [FoodSection(type: .none, items: foods)]
            newState.currentFoods = [FoodSection(type: .none, items: foods)]
        case .removeFilter(let foods):
            newState.isOrdered = false
            newState.isHiddenSection = false
            newState.currentFoods = foods
        }
        return newState
    }
    
    private func filtering(_ sec: [FoodSection]) -> [FoodSection] {
        var items = sec.sorted()
        var idx = 0
        
        while idx < items.count {
            if items[safe: idx]?.type == items[safe: idx + 1]?.type {
                items[idx].items += items[idx + 1].items
                items.remove(at: idx + 1)
                idx -= 1
            }
            idx += 1
        }
        
        return items.sorted { $0.type.rawValue < $1.type.rawValue }
    }
}

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
        case search(String?)
    }
    
    enum Mutation {
        case fetch([FoodSection])
        case currentFoods([FoodSection])
        case filter([FoodItem])
        case removeFilter([FoodSection])
    }
    
    struct State {
        var isOrdered: Bool = false
        var isHiddenSection: Bool = false
        var currentFoods = [FoodSection]()
        var totalCount: Int = 0
    }
    
    private var cnt = 0
    private let alertService: AlertServiceType
    private let repo: FoodItemStorage
    var fetchedFoods: [FoodSection] = []
    var filterFoods: [FoodSection] = []
    var initialState = State()
    
    init(_ alertService: AlertServiceType, _ task: FoodItemStorage) {
        self.alertService = alertService
        self.repo = task
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .load:
            let foods = repo.fetchItems()
            return .just(.fetch(makeSections(foods)))
            
        case .search(let string):
            if string != "", let text = string {
                var items: [FoodItem] = []
                
                for section in self.fetchedFoods {
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
                return .just(.removeFilter(self.fetchedFoods))
            }
            
        case .orderBy:
            let alertActions: [FoodSortAlertAction] = [.frozen, .roomTem, .coldTem, .moreDay, .lessDay, .cancel]
            
            return alertService.show(
                title: "필터링 종류",
                message: nil,
                preferredStyle: .actionSheet,
                actions: alertActions
            )
            .flatMap { alertAction -> Observable<Mutation> in
                var items: [FoodItem] = []
                let sec = self.currentState.isOrdered ? self.filterFoods : self.fetchedFoods
                sec.forEach {
                    items += $0.items
                }
                
                switch alertAction {
                case .roomTem:
                    return .just(.currentFoods([FoodSection(type: .none, items: items.filter { $0.itemPlace == .roomTem })]))
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
                case .cancel:
                    // 만약 검색값이 있다면 filtered 를 보여줘야댐
                    if self.currentState.isOrdered {
                        return .just(.currentFoods(self.filterFoods))
                    } else {
                        return .just(.currentFoods(self.fetchedFoods))
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
        case .fetch(let foods):
            self.fetchedFoods = foods
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
        newState.totalCount = cnt
        
        return newState
    }
    
    private func makeSections(_ items: [FoodItem]) -> [FoodSection] {
        var sectionsArr = [FoodSection]()
        
        self.cnt = items.count
        
        items.forEach { item in
            if item.number == 0 {
                return
            }
            if sectionsArr.contains (where: {$0.type == item.foodType } ) {
                if let index = sectionsArr.firstIndex(where: {$0.type == item.foodType }) {
                    sectionsArr[index].items.append(item)
                }
            } else {
                let newSection = FoodSection(type: item.foodType, items: [item])
                sectionsArr.append(newSection)
            }
        }
        
        return sectionsArr.sorted()
    }
}

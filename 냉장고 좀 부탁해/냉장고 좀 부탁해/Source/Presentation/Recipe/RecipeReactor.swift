//
//  RecipeReactor.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/29.
//

import Foundation

import ReactorKit

final class RecipeReactor: Reactor {
    var initialState = State(categories: [])
    private let coordinator: RecipeCoordinatorProtocol
    private let repo: DataTransferService
    
    enum Action {
        case load
        case itemSelected(IndexPath)
    }
    
    struct State {
        var categories: [Category]
    }
    
    enum Mutation {
        case fetchCategories([Category])
        case move
    }
    
    init(_ coordinator: RecipeCoordinatorProtocol, _ repo: DataTransferService) {
        self.coordinator = coordinator
        self.repo = repo
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case  .itemSelected(let item):
            coordinator.moveToDetail(MealType.allCases[item.item])
            return .just(.move)
            
        case .load:
            var cate = [Category]()
            repo.request(with: APIEndpoints.getCategories()) { result in
                cate = result?.categories ?? []
            }
            return .just(.fetchCategories(cate))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newstate = state
        
        switch mutation {
        case .move:
            print("ASdasdasd")
        case .fetchCategories(let aasd):
            newstate.categories = aasd
        }
        
        return newstate
    }
}

enum MealType: String, CaseIterable {
    case Beef
    case Chicken
    case Dessert
    case Lamb
    case Miscellaneous
    case Pasta
    case Pork
    case Seafood
    case Side
    case Starter
    case Vegan
    case Vegetarian
    case Breakfast
    case Goat
    
    var description: String {
        switch self {
        case .Beef: return "소고기"
        case .Breakfast: return "조식"
        case .Chicken: return "닭고기"
        case .Dessert: return "후식"
        case .Goat: return "염소고기"
        case .Lamb: return "양고기"
        case .Miscellaneous: return "혼종?"
        case .Pasta: return "파스타"
        case .Pork: return "돼지고기"
        case .Seafood: return "해산물"
        case .Side: return "곁들임 요리"
        case .Starter: return "에피타이저"
        case .Vegan: return "비건"
        case .Vegetarian: return "채식주의"
        }
    }
}

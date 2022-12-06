//
//  RecipeListReactor.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/31.
//

import Foundation

import ReactorKit
import RxSwift
import RxCocoa

let mealsEvent = PublishSubject<[FoodDetailResponseDTO]>()

final class RecipeListReactor: Reactor {
    enum Action {
        case load(category: String)
    }
    
    struct State {
        var meals: [FoodDetailResponseDTO]
        var isLoaded = true
    }
    
    enum Mutation {
        case loadMeals([FoodDetailResponseDTO])
    }
    
    var initialState = State(meals: [])
    
    private let repo: Provider
    
    init(_ repo: Provider) {
        self.repo = repo
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load(let category):
            let dto = FoodRequestDTO(c: category)
            repo.request(with: APIEndpoints.getFood(with: dto)) { result in
                switch result {
                case let .success(responseDTO):
                    mealsEvent.onNext(responseDTO.meals ?? [])
                case let .failure(error):
                    print(error)
                    mealsEvent.onNext([])
                }
            }
            
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let meals = mealsEvent.flatMap { infos -> Observable<Mutation> in
            return .just(.loadMeals(infos))
        }
        
        return Observable.merge(mutation, meals)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .loadMeals(let meals):
            newState.meals = meals
            return newState
        }
    }
}

//
//  RecipeCategoryReactor.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/29.
//

import Foundation

import ReactorKit

let categoryEvent = PublishSubject<[Category]>()

final class RecipeCategoryReactor: Reactor {
    var initialState = State(categories: [])
   
    private let repo: Provider
    
    enum Action {
        case load
    }
    
    struct State {
        var categories: [Category]
    }
    
    enum Mutation {
        case fetchCategories([Category])
    }
    
    init(_ repo: Provider) {
        self.repo = repo
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .load:
            repo.request(with: APIEndpoints.getCategories()) { result in
                switch result {
                case let .success(categories):
                    categoryEvent.onNext(categories.categories)
                case let .failure(error):
                    print(error)
                    categoryEvent.onNext([])
                }
            }
            
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let event = categoryEvent.flatMap { categories -> Observable<Mutation> in
            return .just(.fetchCategories(categories))
        }
        return Observable.merge(mutation, event)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newstate = state
        
        switch mutation {
        case .fetchCategories(let category):
            newstate.categories = category
        }
        
        return newstate
    }
}

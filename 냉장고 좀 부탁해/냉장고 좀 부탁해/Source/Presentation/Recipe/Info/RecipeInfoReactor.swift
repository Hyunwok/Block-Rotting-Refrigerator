//
//  RecipeInfoReactor.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/09/02.
//

import Foundation

import ReactorKit
import RxSwift

let foodInfoEvent = PublishSubject<[FoodInfoDetailResponseDTO]>()

final class RecipeInfoReactor: Reactor {
    enum Action {
        case load(id: String)
    }
    
    struct State {
        var data: [FoodInfoDetailResponseDTO] = []
        var isHiddenYoutube = true
    }
    
    enum Mutation {
        case loadedData([FoodInfoDetailResponseDTO])
    }
    
    var initialState = State()
    private let repo: Provider
   
    
    init(_ repo: Provider) {
        self.repo = repo
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load(let id):
            let dto = FoodInfoRequestDTO(i: id)
            repo.request(with: APIEndpoints.getFoodInfo(with: dto)) { result in
                switch result {
                case .success(let foodDTO):
                    foodInfoEvent.onNext(foodDTO.meals ?? [])
                case .failure(let error):
                    print(error)
                    foodInfoEvent.onNext([])
                }
            }
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let event = foodInfoEvent.flatMap { event -> Observable<Mutation> in
            return .just(.loadedData(event))
        }
        
        return Observable.merge(event, mutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .loadedData(let data):
            newState.isHiddenYoutube = data.first?.strYoutube == ""
            newState.data = data
        }
        
        return newState
    }
}

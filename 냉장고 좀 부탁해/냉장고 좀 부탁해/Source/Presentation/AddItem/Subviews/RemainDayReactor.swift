//
//  RemainDayReactor.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/11/10.
//

import Foundation

import ReactorKit

final class RemainDayReactor: Reactor {
    var initialState = State()
    
    enum Action {
        case slided(Float)
    }
    
    struct State {
        var dayStr: String = "1"
        var infoStr: String = "일"
    }
    
    enum Mutation {
        case value(Int)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .slided(let floatValue):
            return .just(.value(Int(floatValue)))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .value(let value):
            if value == 31 {
                newState.dayStr = "30"
                newState.infoStr = "일 이상"
            } else {
                newState.dayStr = String(value)
                newState.infoStr = "일"
            }
        }
        return newState
    }
}

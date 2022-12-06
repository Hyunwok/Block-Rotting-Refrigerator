//
//  AddNameAndImageReactor.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/11/10.
//

import Foundation

import ReactorKit

final class AddNameAndImageReactor: Reactor {
    enum Action {
        case addedImage(UIImage?)
    }
    
    struct State {
        var image: UIImage? = nil
    }
    
    enum Mutation {
        case image(UIImage?)
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addedImage(let image):
            return .just(.image(image))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .image(let image):
            newState.image = image
        }
        return newState
    }
}

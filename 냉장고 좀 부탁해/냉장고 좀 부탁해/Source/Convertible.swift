//
//  Convertible.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/28.
//

import Foundation

import RealmSwift

protocol ConvertibleToRealmObject {
    associatedtype O: Object
    
    func toRealmObject() -> O
}

protocol ConvertibleToModel {
    associatedtype M
    
    func toModel() -> M
}

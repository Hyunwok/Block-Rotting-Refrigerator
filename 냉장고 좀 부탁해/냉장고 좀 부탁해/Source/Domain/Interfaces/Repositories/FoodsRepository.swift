//
//  FoodsRepository.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/22.
//

import Foundation

import RealmSwift
import Realm

protocol FoodsRepository {
    func delete(_ item: FoodSectionDTO, _ completion: (Bool) -> Void)
    @discardableResult
    func deleteAll() -> Bool
    func fetch<T: RealmFetchable& ConvertibleToModel>() -> [T]
    func save<T: RealmSwiftObject>(_ item: T, _ completion: (Bool) -> Void)
    func update<T: RealmSwiftObject>(_ item: T, _ completion: (Bool) -> Void)
}

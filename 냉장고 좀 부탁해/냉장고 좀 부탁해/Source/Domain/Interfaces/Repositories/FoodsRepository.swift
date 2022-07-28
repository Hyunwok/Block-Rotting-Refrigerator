//
//  FoodsRepository.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/22.
//

import Foundation

protocol FoodsRepository {
    func fetch() -> [FoodSectionDAO]
    func save(_ foods: [FoodSectionDAO]) -> Bool
    func delete(_ food: FoodItemDAO) -> Bool
}

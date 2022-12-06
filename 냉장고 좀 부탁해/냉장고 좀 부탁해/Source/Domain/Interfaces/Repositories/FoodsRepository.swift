//
//  FoodsRepository.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/22.
//

import Foundation

import RealmSwift
import Realm

protocol FoodItemStorage {
    func saveItem(_ item: FoodItem, _ completion: (Bool) ->())
    func fetchItems() -> [FoodItem]
    
    func updateItem(_ item: FoodItem, _ completion: (Bool)->())
    func updateAllItems()
    
    func deleteItem(_ item: FoodItem, _ completion: (Bool)->())
    func deleteAllItems()  
}

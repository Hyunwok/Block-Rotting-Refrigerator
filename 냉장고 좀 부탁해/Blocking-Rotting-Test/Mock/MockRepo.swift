//
//  MockRepo.swift
//  Blocking-Rotting-Test
//
//  Created by 이현욱 on 2022/09/15.
//

import Foundation
import RealmSwift
import Realm
@testable import 냉장고_좀_부탁해

class MockRepo: FoodItemStorage {
    var isFail: Bool
    
    init(_ isFail: Bool = false) {
        self.isFail = isFail
    }
    
    func saveItem(_ item: FoodItem, _ completion: (Bool) ->()) {
        print("save")
    }
    
    func fetchItems() -> [FoodItem] {
        if isFail {
            return []
        } else {
            let food1 = FoodItem(name: "test1",
                                 remainingDay: 10,
                                 number: 1,
                                 itemImage: nil,
                                 itemPlace: .roomTem,
                                 foodType: FoodType(rawValue: 1)!)
            
            let food2 = FoodItem(name: "test2",
                                 remainingDay: 2,
                                 number: 2,
                                 itemImage: nil,
                                 itemPlace: .coldTem,
                                 foodType: FoodType(rawValue: 1)!)
            
            let food3 = FoodItem(name: "test3",
                                 remainingDay: 1,
                                 number: 0,
                                 itemImage: nil,
                                 itemPlace: .roomTem,
                                 foodType: FoodType(rawValue: 2)!)
            
            let food4 = FoodItem(name: "test4",
                                 remainingDay: 0,
                                 number: 1,
                                 itemImage: nil,
                                 itemPlace: .frozenTem,
                                 foodType: FoodType(rawValue: 3)!)
            
            let food5 = FoodItem(name: "test5",
                                 remainingDay: 6,
                                 number: 1,
                                 itemImage: nil,
                                 itemPlace: .frozenTem,
                                 foodType: FoodType(rawValue: 0)!)
            
            return [food1, food2, food3, food4, food5]
        }
        
    }
    
    func updateItem(_ item: 냉장고_좀_부탁해.FoodItem, _ completion: (Bool) -> ()) {
        print("updateItem")
    }
    
    func updateAllItems() {
        print("updateAllItems")
    }
    
    func deleteItem(_ item: 냉장고_좀_부탁해.FoodItem, _ completion: (Bool) -> ()) {
        print("deleteItem")
    }
    
    func deleteAllItems() {
        print("deleteAllItems")
    }
}

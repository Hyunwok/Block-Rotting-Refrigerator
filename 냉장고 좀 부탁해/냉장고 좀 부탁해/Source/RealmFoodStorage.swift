//
//  RealmFoodStorage.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/21.
//

import Foundation

import RealmSwift

final class RealmFoodStorage {
    var realm: Realm?
    
    init() {
        do {
            realm = try Realm()
        } catch {
            //          logger.error("Realm Initialization Error: \(error)")
        }
    }
    
    func fetch() -> [FoodSectionDAO] {
        guard let `realm` = realm else { return [] }
        let foods = realm.objects(FoodSectionDAO.self)
        return foods.toArray()
    }
    
    func save(_ foods: [FoodSectionDAO]) -> Bool {
        guard let `realm` = realm else { return false }
        do {
            try! realm.write {
                for food in foods {
                    realm.add(food)
                }
            }
            return true
        } catch {
            print("ASDASDASD")
            return false
        }
    }
    
    func delete(_ food: FoodItemDAO) -> Bool {
        return true
    }
    
    
}

extension RealmFoodStorage: FoodsRepository { }

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}

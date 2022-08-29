//
//  RealmFoodStorage.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/21.
//

import Foundation

import Realm
import RealmSwift

final class RealmFoodStorage {
    var realm: Realm?
    
    init() {
        do {
            realm = try Realm(configuration: .defaultConfiguration)
            //            realm.
        } catch {
            print(error.localizedDescription)
            //          logger.error("Realm Initialization Error: \(error)")
        }
    }
    
    func fetch<T: RealmFetchable& ConvertibleToModel>() -> [T] {
        guard let `realm` = realm else { return [] }
        let foods = realm.objects(T.self)
        return foods.toArray()
    }
    
    func save<T>(_ item: T, _ completion: (Bool) -> Void) where T : RealmSwiftObject {
        guard let `realm` = realm else { return completion(false) }
        do {
            try realm.write {
                realm.add(item)
            }
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func update<T>(_ item: T, _ completion: (Bool) -> Void) where T : RealmSwiftObject {
        guard let `realm` = realm else { return completion(false) }
        
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func delete(_ item: FoodSectionDTO, _ completion: (Bool) -> Void) {
        guard let `realm` = realm else { return completion(false) }
        
        if let objectToRemove = realm.objects(FoodSectionDTO.self).filter(NSPredicate(format: "id = %@", item.id)).first {
            do {
                try realm.write {
                    realm.delete(objectToRemove)
                }
                completion(true)
            } catch {
                completion(false)
            }
        }
        completion(false)
    }
    
    @discardableResult
    func deleteAll() -> Bool {
        guard let `realm` = realm else { return false }
        do {
            try realm.write {
                realm.deleteAll()
            }
            return true
        } catch {
            return false
        }
    }
}

extension RealmFoodStorage: FoodsRepository { }

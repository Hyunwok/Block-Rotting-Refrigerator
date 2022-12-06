//
//  RealmFoodStorage.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/21.
//

import Foundation

import Realm
import RealmSwift

final class RealmFoodItemStorage: FoodItemStorage {
    var realm: Realm?
    
    init() {
        do {
            realm = try Realm(configuration: .defaultConfiguration)
        } catch {
            print(error.localizedDescription)
            //          logger.error("Realm Initialization Error: \(error)")
        }
    }
    
    func saveItem(_ item: FoodItem, _ completion: (Bool) ->()) {
        guard let `realm` = realm else { return completion(false) }
        
        do {
            try realm.write {
                realm.add(item.toRealmObject())
            }
            return completion(true)
        } catch {
            return completion(false)
        }
    }
    
    func updateItem(_ item: FoodItem, _ completion: (Bool) -> ()) {
        guard let `realm` = realm else { return completion(false) }
        
        if let objectToModify = realm.objects(FoodItemDTO.self).filter(NSPredicate(format: "id = %@", item.id)).first {
            do {
                try realm.write {
                    ImageSaver.deleteImageFromDocumentDirectory(imageName: objectToModify.itemImageName)
                    objectToModify.number = item.number
                    objectToModify.itemImageName = ImageSaver.saveImageToDocumentDirectory(imageName: UUID().uuidString, image: item.itemImage)
                }
                return completion(true)
            } catch {
                return completion(false)
            }
        }
    }
    
    func fetchItems() -> [FoodItem] {
        guard let `realm` = realm else { return [] }
        let foodDTOs = realm.objects(FoodItemDTO.self).toArray()
        let foods = foodDTOs.map { $0.toModel() }
        return foods
    }
    
    func deleteItem(_ item: FoodItem, _ completion: (Bool)->()) {
        guard let `realm` = realm else { return completion(false) }
        
        if let objectToRemove = realm.objects(FoodItemDTO.self).filter(NSPredicate(format: "id = %@", item.id)).first {
            do {
                try realm.write {
                    realm.delete(objectToRemove)
                    ImageSaver.deleteImageFromDocumentDirectory(imageName: objectToRemove.itemImageName)
                }
                completion(true)
            } catch {
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
    func deleteAllItems() {
        guard let `realm` = realm else { return }
        
        let foodDTOs = realm.objects(FoodItemDTO.self)
        for foodDTO in foodDTOs {
            do {
                try realm.write {
                    realm.delete(foodDTO)
                }
            } catch {
                
            }
        }
    }
    
    func updateAllItems() {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: UserDefaultStorage.shared.lastStartDate)
        let components = abs(calendar.dateComponents([.day], from: date1, to: date2).day ?? 0)
        
        if components > 0, let `realm` = realm {
            let foodItemDTOs = realm.objects(FoodItemDTO.self).toArray()
            for foodItemDTO in foodItemDTOs {
                try! realm.write {
                    foodItemDTO.remainingDay -= components
                }
            }
            
            UserDefaultStorage.shared.lastStartDate = Date()
        }
    }
}

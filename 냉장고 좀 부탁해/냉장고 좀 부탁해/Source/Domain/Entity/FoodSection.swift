//
//  FoodSection.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/29.
//

import Foundation

import RealmSwift

struct FoodSection: ConvertibleToRealmObject {
    let type: TabType
    let items: [FoodItem]
    
    func toRealmObject() -> FoodSectionDAO {
        let realmObject = FoodSectionDAO()
        realmObject.type = type.rawValue
        realmObject.items.append(objectsIn: items.map { $0.toRealmObject()})
        return realmObject
    }
}

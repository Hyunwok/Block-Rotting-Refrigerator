//
//  FoodSection.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/13.
//

import Foundation

import RealmSwift
import RxDataSources

struct FoodSection {
    var id: String = UUID().uuidString
    let type: FoodType
    var items: [Item]
}

extension FoodSection: SectionModelType {
    typealias Item = FoodItem
    
    init(original: FoodSection, items: [Item]) {
        self = original
        self.items = items
    }
}

extension FoodSection: ConvertibleToRealmObject {
    func toRealmObject() -> FoodSectionDTO {
        let realmObject = FoodSectionDTO()
        realmObject.id = self.id
        realmObject.type = type.rawValue
        realmObject.items.append(objectsIn: self.items.map { $0.toRealmObject() })
        return realmObject
    }
}

extension FoodSection: Comparable {
    static func < (lhs: FoodSection, rhs: FoodSection) -> Bool {
        return lhs.type.rawValue < rhs.type.rawValue
    }
    
    static func == (lhs: FoodSection, rhs: FoodSection) -> Bool {
        return lhs.type.rawValue == rhs.type.rawValue
    }
}

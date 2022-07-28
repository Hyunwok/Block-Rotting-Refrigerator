//
//  FoodItem.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/20.
//

import UIKit
import RealmSwift

struct FoodItem: ConvertibleToRealmObject {
    let name: String
    let remainingDay: Int
    let number: Int
    let itemImageName: String?
    let itemPlace: ItemPlace
    
    init(name: String, remainingDay: Int, number: Int, itemImageName: String?, itemPlace: ItemPlace) {
        self.number = number
        self.name = name
        self.remainingDay = remainingDay
        self.itemImageName = itemImageName
        self.itemPlace = itemPlace
    }
    
    func toRealmObject() -> FoodItemDAO {
        let realmObject = FoodItemDAO()
        realmObject.name = name
        realmObject.remainingDay = remainingDay
        realmObject.number = number
        realmObject.itemImageName = itemImageName
        realmObject.itemPlace = itemPlace.rawValue
        return realmObject
    }
}

enum ItemPlace: Int {
    case roomTem = 0
    case frozenTem
    case coldTem
}

extension ItemPlace: CustomStringConvertible {
    var description: String {
        switch self {
        case .roomTem:
            return "cloud.sun" // 상온
        case .frozenTem:
            return "snowflake" // 냉동
        case .coldTem:
            return "wind.snow" // 냉장
        }
    }
}



//
//  FoodItem.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/20.
//

import UIKit

import RealmSwift

struct FoodItem {
    var foodType: FoodType
    var id: String
    var name: String
    var remainingDay: Int
    var number: Int
    var itemImage: UIImage?
    var itemPlace: ItemPlace
    
    init(id: String = UUID().uuidString, name: String, remainingDay: Int, number: Int, itemImage: UIImage?, itemPlace: ItemPlace, foodType: FoodType) {
        self.id = id
        self.number = number
        self.name = name
        self.remainingDay = remainingDay
        self.itemImage = itemImage
        self.itemPlace = itemPlace
        self.foodType = foodType
    }
}

extension FoodItem: ConvertibleToRealmObject {
    func toRealmObject() -> FoodItemDTO {
        let realmObject = FoodItemDTO()
        realmObject.name = name
        realmObject.remainingDay = remainingDay
        realmObject.number = number
        realmObject.id = id
        realmObject.itemImageName = ImageSaver.saveImageToDocumentDirectory(imageName: UUID().uuidString, image: itemImage)
        realmObject.itemPlace = itemPlace.rawValue
        realmObject.foodType = foodType.rawValue
        return realmObject
    }
}

enum ItemPlace: Int {
    case roomTem = 0
    case coldTem = 1
    case frozenTem = 2
}

extension ItemPlace {
    var description: String {
        switch self {
        case .roomTem: // 상온
            return "cloud.sun.fill"
        case .frozenTem: // 냉동
            if #available(iOS 15.0, *) {
                return "snowflake"
            } else {
                return "cloud.snow.fill"
            }
        case .coldTem: // 냉장
            return "wind"
        }
    }
    
    var place: String {
        switch self {
        case .roomTem: return "상온"
        case .frozenTem: return "냉동"
        case .coldTem: return "냉장"
        }
    }
}

extension FoodItem: Equatable { }

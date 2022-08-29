//
//  RealmFoodDTO+Mapping.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/21.
//

import Foundation

import RealmSwift

final class FoodItemDTO: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var remainingDay: Int = 0
    @objc dynamic var number: Int = 0
    @objc dynamic var itemImageName: String? = nil
    @objc dynamic var itemPlace: Int = 0
    
    var itemEnum: ItemPlace {
        get {
            return ItemPlace(rawValue: itemPlace) ?? .coldTem
        }
        set {
            itemPlace = newValue.rawValue
        }
    }
}

extension FoodItemDTO: ConvertibleToModel {
    func toModel() -> FoodItem {
        return FoodItem(name: name,
                        remainingDay: remainingDay,
                        number: number,
                        itemImage: ImageSaver.loadImageFromDocumentDirectory(imageName: itemImageName),
                        itemPlace: itemEnum)
    }
}

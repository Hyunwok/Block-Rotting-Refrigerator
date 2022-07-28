//
//  RealmFoodEntity+Mapping .swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/21.
//

import Foundation

import RealmSwift

final class FoodSectionDAO: Object, ConvertibleToModel {
    @objc dynamic var type: Int = 0
    var items: List<FoodItemDAO> = List()
    
    var tabTypeEnum: TabType {
        get {
            return TabType(rawValue: type)!
        }
        set {
            type = newValue.rawValue
        }
    }
    
    func toModel() -> FoodSection {
        return FoodSection(type: tabTypeEnum,
                           items: Array(items.map { $0.toModel() }))
    }
}

final class FoodItemDAO: Object, ConvertibleToModel {
    @objc dynamic var name: String = ""
    @objc dynamic var remainingDay: Int = 0
    @objc dynamic var number: Int = 0
    @objc dynamic var itemImageName: String? = nil
    @objc dynamic var itemPlace: Int = 0
    
    var itemEnum: ItemPlace {
        get {
            return ItemPlace(rawValue: itemPlace)!
        }
        set {
            itemPlace = newValue.rawValue
        }
    }
    
    func toModel() -> FoodItem {
        return FoodItem(name: name,
                        remainingDay: remainingDay,
                        number: number,
                        itemImageName: itemImageName,
                        itemPlace: ItemPlace(rawValue: itemPlace) ?? .coldTem)
    }
}


////
////  RealmFoodSectionDTO+Mapping.swift
////  냉장고 좀 부탁해
////
////  Created by 이현욱 on 2022/08/15.
////
//
//import Foundation
//
//import RealmSwift
//
//final class FoodSectionDTO: Object {
//    @objc dynamic var type: Int = 0
//    var items: List<FoodItemDTO> = List()
//    
//    var tabTypeEnum: FoodType {
//        get {
//            return FoodType(rawValue: type)!
//        }
//        set {
//            type = newValue.rawValue
//        }
//    }
//}
//
//extension FoodSectionDTO: ConvertibleToModel {
//    func toModel() -> FoodSection {
//        return FoodSection(type: self.tabTypeEnum,
//                           items: Array(items.map { $0.toModel() }))
//    }
//}

//
//  FoodItem.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/20.
//

import UIKit

enum ItemPlace: String {
    case roomTem = "cloud.sun" // 상온
    case frozenTem = "snowflake" // 냉동
    case coldTem = "wind.snow" // 냉장
}

struct FoodItem {
    let itemPlace: ItemPlace
    let name: String
    let remainingDay: Int
    let number: Int
    let itemImage: UIImage?
}

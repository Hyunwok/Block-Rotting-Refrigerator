//
//  FoodCategoryDTO.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/29.
//

import Foundation

struct Categories: Codable {
    let categories: [Category]
}

struct Category: Codable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}

//
//  FoodResponseDTO.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/29.
//

import Foundation

struct FoodResponseDTO: Codable {
    let meals: [FoodInfoResponseDTO]
}

struct FoodInfoResponseDTO: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

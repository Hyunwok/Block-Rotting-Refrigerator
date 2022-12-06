//
//  FoodResponseDTO.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/29.
//

import Foundation

// Food Request DTO
struct FoodRequestDTO: Codable {
    let c: String
}

// Food Response DTO
struct FoodResponseDTO: Codable {
    let meals: [FoodDetailResponseDTO]?
}

struct FoodDetailResponseDTO: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

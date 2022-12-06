//
//  FoodCategoryDTO.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/29.
//

import Foundation

enum MealType: String, CaseIterable {
    case Beef
    case Chicken
    case Dessert
    case Lamb
    case Miscellaneous
    case Pasta
    case Pork
    case Seafood
    case Side
    case Starter
    case Vegan
    case Vegetarian
    case Breakfast
    case Goat
    
    var description: String {
        switch self {
        case .Beef: return "소고기"
        case .Breakfast: return "조식"
        case .Chicken: return "닭고기"
        case .Dessert: return "후식"
        case .Goat: return "염소고기"
        case .Lamb: return "양고기"
        case .Miscellaneous: return "혼합"
        case .Pasta: return "파스타"
        case .Pork: return "돼지고기"
        case .Seafood: return "해산물"
        case .Side: return "곁들임 요리"
        case .Starter: return "에피타이저"
        case .Vegan: return "비건"
        case .Vegetarian: return "채식주의"
        }
    }
}

struct Categories: Codable {
    let categories: [Category]
}

struct Category: Codable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}

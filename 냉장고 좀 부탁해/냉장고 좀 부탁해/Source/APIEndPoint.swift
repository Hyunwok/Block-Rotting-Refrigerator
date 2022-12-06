//
//  APIEndPoint.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/29.
//

import Foundation

struct APIEndpoints {
    static func getFood(with dto: FoodRequestDTO) -> Endpoint<FoodResponseDTO> {
            return Endpoint(baseURL: "https://www.themealdb.com/",
                            path: "api/json/v1/1/filter.php",
                            method: .get,
                            queryParameters: dto)
        
    }
    
    static func getCategories() -> Endpoint<Categories> {
        return Endpoint(baseURL: "https://www.themealdb.com/",
                        path: "api/json/v1/1/categories.php",
                        method: .get,
                        sampleData: MockData.category)
    }
    
    static func getFoodInfo(with dto: FoodInfoRequestDTO) -> Endpoint<FoodInfoResponseDTO> {
        return Endpoint(baseURL: "https://www.themealdb.com/",
                        path: "api/json/v1/1/lookup.php",
                        method: .get,
                        queryParameters: dto)
    }
}

//
//  APIEndPoint.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/29.
//

import Foundation

struct APIEndpoints {
    
//    static func getMovies(with moviesRequestDTO: MoviesRequestDTO) -> Endpoint<MoviesResponseDTO> {
//
//        return Endpoint(path: "3/search/movie/",
//                        method: .get,
//                        queryParametersEncodable: moviesRequestDTO)
//    }
//
//    static func getMoviePoster(path: String, width: Int) -> Endpoint<Data> {
//
//        let sizes = [92, 154, 185, 342, 500, 780]
//        let closestWidth = sizes.enumerated().min { abs($0.1 - width) < abs($1.1 - width) }?.element ?? sizes.first!
//
//        return Endpoint(path: "t/p/w\(closestWidth)\(path)",
//                        method: .get,
//                        responseDecoder: RawDataResponseDecoder())
//    }
    
    static func getFood(with foodRequestDTO: FoodRequestDTO) -> Endpoint<FoodResponseDTO> {
        return Endpoint(path: "api/json/v1/1/", // filter.php?c=Seafood
                        method: .get,
                        queryParametersEncodable: foodRequestDTO)
    }
    
    static func getCategories() -> Endpoint<Categories> {
        return Endpoint(path: "api/json/v1/1/categories.php",
                        method: .get)
    }
}

// get random with category
//www.themealdb.com/api/json/v1/1/filter.php?c=Seafood


// get category
//www.themealdb.com/api/json/v1/1/categories.php

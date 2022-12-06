//
//  Recipe_Test.swift
//  Blocking-Rotting-Test
//
//  Created by 이현욱 on 2022/09/15.
//

import XCTest

@testable import 냉장고_좀_부탁해

class Recipe_Test: XCTestCase {
    func test_통신을_잘_받아오는지() throws {
        // given
        let expectation = XCTestExpectation()
        let sut = ProviderImpl(session: MockURLSession())
        let responseMock = try? JSONDecoder().decode(Categories.self, from: MockData.category)
        
        sut.request(with: APIEndpoints.getCategories()) { result in
            switch result {
            case .success(let category):
                XCTAssertEqual(category.categories.first?.idCategory, responseMock?.categories.first?.idCategory)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_통신이_잘_실패하는지() throws {
        let expectation = XCTestExpectation()
        let sut = ProviderImpl(session: MockURLSession(isFail: true))
        
        sut.request(with: APIEndpoints.getCategories()) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "알수 없는 에러입니다.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

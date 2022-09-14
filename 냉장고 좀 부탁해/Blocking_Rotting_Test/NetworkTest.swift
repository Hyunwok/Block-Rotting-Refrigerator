//
//  NetworkTest.swift
//  NetworkTest
//
//  Created by 이현욱 on 2022/09/14.
//

import XCTest
@testable import 냉장고_좀_부탁해

class NetworkTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_whenhasStatusCodeUsedWithWrongError_shouldReturnFalse() {
        //when
        let sut = NetworkError.notConnected
        let asd = NetworkError.error(statusCode: 401, data: nil)
        
        //then
        XCTAssertTrue(asd.hasStatusCode(401))
        print(sut.hasStatusCode(404))
        XCTAssertFalse(sut.hasStatusCode(200))
    }
}

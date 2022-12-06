//
//  MockURLSession.swift
//  Blocking-Rotting-Test
//
//  Created by 이현욱 on 2022/10/06.
//

import Foundation

@testable import 냉장고_좀_부탁해

class MockURLSession: URLSessionable {
    var isFail: Bool
//    var endPointURL: URL
//    var endPointBaseURL: String
//    var sampleData: Data?
//    var path: String
//    var body: Encodable?
//    var query: Encodable?
//    var header: [String: String]?
//    var urlRequest: URLRequest?
//    
    init(isFail: Bool = false) {
        self.isFail = isFail
//        self.endPointBaseURL = endPoint.baseURL
//        self.sampleData = endPoint.sampleData
//        self.path = endPoint.path
//        self.endPointURL = try! endPoint.url()
//        self.body = endPoint.bodyParameters
//        self.header = endPoint.headers
//        self.query = endPoint.queryParameters
//        self.urlRequest = try? endPoint.getUrlRequest()
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let mockDataTask = MockURLSessionDataTask()
        
        let endpoint = APIEndpoints.getCategories()
        
        let failResponse = HTTPURLResponse(url: try! endpoint.url(),
                                              statusCode: 301,
                                              httpVersion: "2",
                                              headerFields: nil)
        
        let sussessResponse = HTTPURLResponse(url: try! endpoint.url(),
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)

        mockDataTask.resumeDidCall = {
            if self.isFail {
                completionHandler(nil, failResponse, NetworkError.unknownError)
            } else {
                completionHandler(MockData.category, sussessResponse, nil)
            }
        }
        
        return mockDataTask
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let mockDataTask = MockURLSessionDataTask()
        
        let failResponse = HTTPURLResponse(url: URL(string: "")!,
                                              statusCode: 301,
                                              httpVersion: "2",
                                              headerFields: nil)
        
        let sussessResponse = HTTPURLResponse(url: URL(string: "")!,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)

        mockDataTask.resumeDidCall = {
            if self.isFail {
                completionHandler(nil, failResponse, NetworkError.unknownError)
            } else {
                completionHandler(MockData.category, sussessResponse, nil)
            }
        }
        
        return mockDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: (() -> ())?
    
    override func resume() {
        resumeDidCall?()
    }
}

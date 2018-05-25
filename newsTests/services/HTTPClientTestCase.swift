//
//  HTTPClientTestCase.swift
//  newsTests
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import XCTest
@testable import news

class HTTPClientTestCase: XCTestCase {
    
    private class Helper: RequestHelperProtocol {
        
        var response: Response<Any>?
        var path: String?
        
        func get(path: String, completion: @escaping (Response<Any>) -> Void) {
            self.path = path
            guard let response = response else { return }
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    private let helper = Helper()
    private var client: HTTPClient!
    
    override func setUp() {
        super.setUp()
        client = HTTPClient(helper: helper, pageSize: 5)
    }
    
    override func tearDown() {
        helper.response = nil
        helper.path = nil
        super.tearDown()
    }
    
    func testCalculatesNewsListBoundsAtFirstPage() {
        // configure helper
        helper.response = .failure(.noInternet)
        // request
        client.loadItems(at: 0) { _ in }
        XCTAssertTrue(helper.path!.contains("first=0"))
        XCTAssertTrue(helper.path!.contains("last=5"))
    }
    
    func testCalculatesNewsListBoundsAtThirdPage() {
        // configure helper
        helper.response = .failure(.noInternet)
        // request
        client.loadItems(at: 2) { _ in }
        XCTAssertTrue(helper.path!.contains("first=10"))
        XCTAssertTrue(helper.path!.contains("last=15"))
    }
    
}

//
//  ListModuleInteractorTests.swift
//  newsTests
//
//  Created by Daniyar Salakhutdinov on 21.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import XCTest
@testable import news

class ListModuleInteractorTests: XCTestCase {
    
    private class FakeCache: ItemsCacheProtocol {
        var items: [NewsItem] = []
    }
    
    private class FakeLoader: ItemsListLoaderProtocol {
        var pageSize: Int = 0
        var response: Response<(items:[NewsItem], stop: Bool)>?
        
        func loadItems(at page: Int, completion: @escaping (Response<(items:[NewsItem], stop: Bool)>) -> Void) {
            guard let response = response else { return }
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    private var cache = FakeCache()
    private var loader = FakeLoader()
    private var interactor: ListModuleInteractor!
    
    override func setUp() {
        super.setUp()
        interactor = ListModuleInteractor()
        interactor.cache = cache
        interactor.loader = loader
    }
    
    override func tearDown() {
        cache.items = []
        loader.pageSize = 0
        loader.response = nil
        super.tearDown()
    }
    
    // MARK: tests
    func testOverridesCacheOnFirstPageLoaded() {
        let item = NewsItem(id: "", name: "", text: "", publicationDate: Date())
        let result = (items: [item, item], stop: false)
        loader.response = .success(result)
        cache.items = [item]
        let expect = expectation(description: "Loading")
        interactor.load(page: 0) { (response) in
            XCTAssertEqual(self.cache.items.count, 2)
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
}

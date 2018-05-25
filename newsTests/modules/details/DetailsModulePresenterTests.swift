//
//  DetailsModulePresenterTests.swift
//  newsTests
//
//  Created by Daniyar Salakhutdinov on 24.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import XCTest
@testable import news

class DetailsModulePresenterTests: XCTestCase {
    
    private class FakeView: DetailsModuleViewInput {
        
        var didIndicate = false
        
        func presentActivityIndicator(text: String) {
            didIndicate = true
        }
        
        func dismissActivityIndicator() {
            
        }
        
        func setContent(_ content: String) {
            
        }
        
        func presentErrorAlert(title: String,
                               repeatHandler: @escaping ViperModuleClosure,
                               cancelHandler: @escaping ViperModuleClosure) {
            
        }
    }
    
    private class FakeInteractor: DetailsModuleInteractorInput {
        
        var cached: String?
        
        func cachedContent(itemId: String) -> String? {
            return cached
        }
        
        func loadDetails(itemId: String, completion: @escaping (Response<NewsDetails>) -> Void) {
            
        }
    }
    
    private class FakeRouter: DetailsModuleRouterInput {
        
        var didClose = false
        
        func closeAnimated() {
            didClose = true
        }
    }
    
    private let interactor = FakeInteractor()
    private let view = FakeView()
    private let router = FakeRouter()
    private var presenter: DetailsModulePresenter!
    
    override func setUp() {
        super.setUp()
        presenter = DetailsModulePresenter()
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }
    
    override func tearDown() {
        interactor.cached = nil
        router.didClose = false
        super.tearDown()
    }
    
    func testPresentsIndicatorIfCacheIsEmpty() {
        presenter.configure(itemId: "id")
        XCTAssertTrue(view.didIndicate)
    }
    
}

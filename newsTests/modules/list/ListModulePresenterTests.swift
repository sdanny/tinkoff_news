//
//  ListModulePresenterTests.swift
//  newsTests
//
//  Created by Daniyar Salakhutdinov on 21.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import XCTest
@testable import news

class ListModulePresenterTests: XCTestCase {
    
    private class FakeView: ListModuleViewInput {
        
        var isLoading = false
        var didPresentError = false
        var didReload = false
        var isRefreshing = false
        var models = [ListModuleNewsItemCellModel]()
        
        func presentActivityIndicator() {
            isLoading = true
        }
        
        func dismissActivityIndicator() {
            isLoading = false
        }
        
        func startRefreshing() {
            isRefreshing = true
        }
        
        func stopRefreshing() {
            isRefreshing = false
        }
        
        func presentErrorAlert(title: String, repeatHandler: @escaping ViperModuleClosure, cancelHandler: @escaping ViperModuleClosure) {
            didPresentError = true
        }
        
        func appendModels(_ models: [ListModuleNewsItemCellModel]) {
            self.models.append(contentsOf: models)
        }
        
        func removeAll() {
            models = []
        }
        
        func reloadData() {
            didReload = true
        }
    }
    
    private class FakeInteractor: ListModuleInteractorInput {
        
        var pageSize: Int = 10
        var page = 0
        var response: Response<(items: [NewsItem], stop: Bool)>?
        var didIncrement = false
        var didLoad: (() -> Void)?
        
        func load(page: Int, completion: @escaping (Response<(items: [NewsItem], stop: Bool)>) -> Void) {
            self.page = page
            guard let response = response else { return }
            DispatchQueue.main.async {
                completion(response)
                self.didLoad?()
            }
        }
        
        var cachedItems: [NewsItem] = []
        
        func counterValue(forItemId itemId: String) -> Int {
            return 0
        }
        
        func incrementCounterValue(forItemId itemId: String) {
            didIncrement = true
        }
    }
    
    private class FakeRouter: ListModuleRouterInput {
        var didOpenDetails = false
        
        func openDetailsModule(itemId: String) {
            didOpenDetails = true
        }
    }
    
    private var interactor = FakeInteractor()
    private var router = FakeRouter()
    private var view = FakeView()
    private var presenter: ListModulePresenter!
    
    override func setUp() {
        super.setUp()
        presenter = ListModulePresenter()
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }
    
    override func tearDown() {
        router.didOpenDetails = false
        interactor.page = 0
        interactor.pageSize = 0
        interactor.response = nil
        interactor.didIncrement = false
        interactor.cachedItems = []
        interactor.didLoad = nil
        view.isLoading = false
        view.didPresentError = false
        view.didReload = false
        view.models = []
        super.tearDown()
    }
    
    // MARK: tests
    func testPresentsCacheOnConfigure() {
        let item = NewsItem(id: "", name: "", text: "", publicationDate: Date())
        interactor.cachedItems = [item, item, item]
        
        presenter.configure()
        XCTAssertEqual(view.models.count, 3)
        XCTAssertTrue(view.isRefreshing)
    }
    
    func testReloadsCellsOnViewAppear() {
        presenter.viewWillAppear()
        XCTAssertTrue(view.didReload)
    }
    
    func testLoadsPagesIncrementally() {
        let item = NewsItem(id: "", name: "", text: "", publicationDate: Date())
        interactor.pageSize = 3
        let result = (items: [item, item, item], stop: false)
        interactor.response = .success(result)
        var call = 0
        let exp = expectation(description: "loading pages")
        interactor.didLoad = {
            guard call < 1 else {
                exp.fulfill()
                return
            }
            call += 1
            XCTAssertEqual(call, self.interactor.page + 1)
            
            self.presenter.didReachBottom()
            XCTAssertEqual(self.interactor.page, 1)
        }
        // start
        presenter.configure()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testDoesntLoadWhileLoading() {
        let item = NewsItem(id: "", name: "", text: "", publicationDate: Date())
        interactor.pageSize = 3
        let result = (items: [item, item, item], stop: false)
        interactor.response = .success(result)
        
        presenter.configure()
        presenter.didReachBottom()
        XCTAssertEqual(interactor.page, 0)
    }
    
    func testRefreshesWithNoLoadingCellOnConfigure() {
        let item = NewsItem(id: "", name: "", text: "", publicationDate: Date())
        interactor.pageSize = 3
        let result = (items: [item, item, item], stop: false)
        interactor.response = .success(result)
        
        presenter.configure()
        XCTAssertFalse(view.isLoading)
    }
}

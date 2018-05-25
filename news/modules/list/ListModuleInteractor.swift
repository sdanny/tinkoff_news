//
//  ListModuleInteractor.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright (c) 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

protocol ItemsListLoaderProtocol {
    var pageSize: Int { get }
    
    func loadItems(at page: Int, completion: @escaping (Response<(items: [NewsItem], stop: Bool)>) -> Void)
}

protocol ItemsListCounterProtocol {
    func counterValue(forItemId itemId: String) -> Int
    func incrementCounterValue(forItemId itemId: String)
}

protocol ItemsCacheProtocol {
    var items: [NewsItem] { get set }
}

class ListModuleInteractor: ListModuleInteractorInput {
    
    var loader: ItemsListLoaderProtocol!
    var counter: ItemsListCounterProtocol!
    var cache: ItemsCacheProtocol!
    
    var pageSize: Int {
        return loader.pageSize
    }
    
    func load(page: Int, completion: @escaping (Response<(items: [NewsItem], stop: Bool)>) -> Void) {
        loader.loadItems(at: page) { [weak self] response in
            guard let `self` = self else { return }
            if page == 0,
                case .success(let result) = response {
                self.cache.items = result.items
            }
            completion(response)
        }
    }
    
    var cachedItems: [NewsItem] {
        return cache.items
    }
    
    func counterValue(forItemId itemId: String) -> Int {
        return counter.counterValue(forItemId: itemId)
    }
    
    func incrementCounterValue(forItemId itemId: String) {
        counter.incrementCounterValue(forItemId: itemId)
    }
}

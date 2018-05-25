//
//  DetailsModuleInteractor.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright (c) 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

protocol DetailsLoaderProtocol {
    func loadDetails(id: String, completion: @escaping (Response<NewsDetails>) -> Void)
}

protocol ContentCacheProtocol {
    func cachedContent(itemId: String) -> String?
    func setContent(_ content: String, ofItem itemId: String)
}

class DetailsModuleInteractor: DetailsModuleInteractorInput {
    
    var loader: DetailsLoaderProtocol!
    var cache: ContentCacheProtocol!
      
    // MARK: input methods
    func cachedContent(itemId: String) -> String? {
        return cache.cachedContent(itemId: itemId)
    }
    
    func setContent(_ content: String, ofItem itemId: String) {
        cache.setContent(content, ofItem: itemId)
    }
    
    func loadDetails(itemId: String, completion: @escaping (Response<NewsDetails>) -> Void) {
        loader.loadDetails(id: itemId, completion: completion)
    }
}

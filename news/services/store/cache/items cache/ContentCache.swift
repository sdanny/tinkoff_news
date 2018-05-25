//
//  ContentCache.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 24.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

protocol ContentCacheStoreBaseProtocol: StoreBaseProtocol {
    func removeItemWithId(_ id: String)
    func allValues() -> [String: String]
    func addValue(id: String, content: String)
}

class ContentCache: ContentCacheProtocol {
    
    let storeBase: ContentCacheStoreBaseProtocol
    private var values: [String: String]
    
    init(storeBase: ContentCacheStoreBaseProtocol) {
        self.storeBase = storeBase
        self.values = storeBase.allValues()
    }
    
    func cachedContent(itemId: String) -> String? {
        return values[itemId]
    }
    
    func setContent(_ content: String, ofItem itemId: String) {
        storeBase.removeItemWithId(itemId)
        storeBase.addValue(id: itemId, content: content)
        storeBase.save()
    }
}

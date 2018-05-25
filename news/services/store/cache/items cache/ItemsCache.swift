//
//  ItemsCache.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 22.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

protocol ItemsCacheStoreBaseProtocol: StoreBaseProtocol {
    func getNewsItems() -> [NewsItem]
    func removeAllItems()
    func appendItems(_ items: [NewsItem])
}

class ItemsCache: ItemsCacheProtocol {
    
    let storeBase: ItemsCacheStoreBaseProtocol
    
    init(storeBase: ItemsCacheStoreBaseProtocol) {
        self.storeBase = storeBase
    }
    
    var items: [NewsItem] {
        get {
            return storeBase.getNewsItems()
        }
        set {
            storeBase.removeAllItems()
            storeBase.appendItems(newValue)
            storeBase.save()
        }
    }
}

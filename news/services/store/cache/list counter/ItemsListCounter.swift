//
//  ItemsListCounter.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 22.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

protocol ItemsListCounterStoreBaseProtocol: StoreBaseProtocol {
    func removeItemWithId(_ id: String)
    func addValue(id: String, count: Int)
    func allValues() -> [String: Int]
}

class ItemsListCounter: ItemsListCounterProtocol {
    
    let storeBase: ItemsListCounterStoreBaseProtocol
    private var values: [String: Int]
    
    init(storeBase: ItemsListCounterStoreBaseProtocol) {
        self.storeBase = storeBase
        self.values = storeBase.allValues()
    }
    
    func counterValue(forItemId itemId: String) -> Int {
        return values[itemId] ?? 0
    }
    
    func incrementCounterValue(forItemId itemId: String) {
        let prev: Int
        if let value = values[itemId] {
            prev = value
        } else {
            prev = 0
        }
        let newValue = prev + 1
        values[itemId] = newValue
        storeBase.removeItemWithId(itemId)
        storeBase.addValue(id: itemId, count: newValue)
        storeBase.save()
    }
}

//
//  ItemsListCounterStoreBase.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 23.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit
import CoreData

class ItemsListCounterStoreBase: ItemsListCounterStoreBaseProtocol, ContextProviderParentProtocol {
    
    let provider: StoreBaseContextProviderProtocol
    
    init(provider: StoreBaseContextProviderProtocol) {
        self.provider = provider
    }
    
    func removeItemWithId(_ id: String) {
        let context = provider.context
        
        let entities = allEntities(id: id)
        entities.forEach { context.delete($0) }
        save()
    }
    
    private func allEntities(id: String? = nil) -> [CountEntity] {
        let context = provider.context
        
        let name = String(describing: CountEntity.self)
        let request = NSFetchRequest<CountEntity>(entityName: name)
        if let id = id {
            request.predicate = NSPredicate(format: "id = %@", id)
        }
        do {
            return try context.fetch(request)
        } catch {
            print("Could not fetch details objects with error: \(error)")
            return []
        }
    }
    
    func addValue(id: String, count: Int) {
        let context = provider.context
        
        let name = String(describing: CountEntity.self)
        guard let description = NSEntityDescription.entity(forEntityName: name, in: context) else { return }
        let entity = CountEntity(entity: description, insertInto: context)
        entity.id = id
        entity.value = Int16(count)
        save()
    }
    
    func allValues() -> [String: Int] {
        let entities = allEntities()
        var values = [String: Int]()
        for entity in entities {
            guard let id = entity.id else { continue }
            values[id] = Int(entity.value)
        }
        return values
    }
}

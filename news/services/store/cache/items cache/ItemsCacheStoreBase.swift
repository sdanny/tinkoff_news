//
//  ItemsCacheStoreBase.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 23.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit
import CoreData

class ItemsCacheStoreBase: ItemsCacheStoreBaseProtocol, ContextProviderParentProtocol {
    
    let provider: StoreBaseContextProviderProtocol
    
    init(provider: StoreBaseContextProviderProtocol) {
        self.provider = provider
    }
    
    func getNewsItems() -> [NewsItem] {
        let context = provider.context
        
        let entities = allEntities(context: context)
        return entities.compactMap { $0.item }
    }
    
    func removeAllItems() {
        let context = provider.context
        
        let entities = allEntities(context: context)
        entities.forEach { context.delete($0) }
    }
    
    private func allEntities(context: NSManagedObjectContext) -> [NewsItemEntity] {
        let request = NSFetchRequest<NewsItemEntity>(entityName: String(describing: NewsItemEntity.self))
        do {
            return try context.fetch(request)
        } catch {
            print("Could not fetch NewsItemEntity objects with error: \(error)")
            return []
        }
    }
    
    func appendItems(_ items: [NewsItem]) {
        let context = provider.context
        
        let name = String(describing: NewsItemEntity.self)
        guard let description = NSEntityDescription.entity(forEntityName: name, in: context) else { return }
        for item in items {
            let object = NewsItemEntity(entity: description, insertInto: context)
            object.update(from: item)
        }
        save()
    }
}

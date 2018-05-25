//
//  ContentCacheStoreBase.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 24.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit
import CoreData

class ContentCacheStoreBase: ContentCacheStoreBaseProtocol, ContextProviderParentProtocol {
    
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
    
    func allValues() -> [String : String] {
        let entities = allEntities()
        var values = [String: String]()
        for entity in entities {
            guard let id = entity.id,
                let content = entity.content else { continue }
            values[id] = content
        }
        return values
    }
    
    private func allEntities(id: String? = nil) -> [NewsContentEntity] {
        let context = provider.context
        
        let name = String(describing: NewsContentEntity.self)
        let request = NSFetchRequest<NewsContentEntity>(entityName: name)
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
    
    func addValue(id: String, content: String) {
        let context = provider.context
        
        let name = String(describing: NewsContentEntity.self)
        guard let description = NSEntityDescription.entity(forEntityName: name, in: context) else { return }
        let entity = NewsContentEntity(entity: description, insertInto: context)
        entity.id = id
        entity.content = content
        save()
    }
}

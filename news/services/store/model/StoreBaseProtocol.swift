//
//  StoreBaseProtocol.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 24.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import Foundation
import CoreData

protocol StoreBaseProtocol {
    func save()
}

protocol ContextProviderParentProtocol {
    var provider: StoreBaseContextProviderProtocol { get }
}

extension StoreBaseProtocol where Self: ContextProviderParentProtocol {
    
    func save() {
        let context = provider.context
        do {
            try context.save()
        } catch {
            print("Could not save managed object context with error: \(error)")
        }
    }
}

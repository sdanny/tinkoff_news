//
//  StoreBaseContextProvider.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit
import CoreData

protocol StoreBaseContextProviderProtocol {
    var context: NSManagedObjectContext { get }
}

/// Class for creating and providing data base managed object context
class StoreBaseContextProvider: StoreBaseContextProviderProtocol {
    
    static func withObjectModel(named name: String) -> StoreBaseContextProvider {
        // URL Documents Directory
        let URLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let applicationDocumentsDirectory = URLs[(URLs.count - 1)]
        // URL Persistent Store
        let url = applicationDocumentsDirectory.appendingPathComponent("\(name).sqlite")
        return StoreBaseContextProvider(url: url)
    }
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    // MARK: - core data stack
    private lazy var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel.mergedModel(from: nil)!
    }()
    
    var context: NSManagedObjectContext {
        return managedObjectContext
    }
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let persistentStoreCoordinator = self.persistentStoreCoordinator
        
        // initialize Managed Object Context
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        //
        let coordinator: NSPersistentStoreCoordinator
        // try create
        do {
            coordinator = try self.tryCreatePersistentStoreCoordinator()
        } catch {
            do {
                // remove previous model and create a new one
                try FileManager.default.removeItem(at: url)
                coordinator = try self.tryCreatePersistentStoreCoordinator()
            } catch {
                abort()
            }
        }
        return coordinator
    }()
    
    private func tryCreatePersistentStoreCoordinator() throws -> NSPersistentStoreCoordinator {
        // initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        // define parameters
        let type: String = NSSQLiteStoreType
        // create
        do {
            // add Persistent Store to Persistent Store Coordinator
            try persistentStoreCoordinator.addPersistentStore(ofType: type, configurationName: nil, at: url, options: nil)
        } catch {
            // populate error
            var userInfo = [String: AnyObject]()
            userInfo[NSLocalizedDescriptionKey] = "There was an error creating or loading the application's saved data." as AnyObject?
            userInfo[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data." as AnyObject?
            
            userInfo[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: NSCocoaErrorDomain, code: 1001, userInfo: userInfo)
            
            print("Store base: unresolved error \(wrappedError), \(wrappedError.userInfo)")
            
            throw error
        }
        
        return persistentStoreCoordinator
    }
}

//
//  NewsContentEntity+CoreDataProperties.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 24.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//
//

import Foundation
import CoreData


extension NewsContentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsContentEntity> {
        return NSFetchRequest<NewsContentEntity>(entityName: "NewsContentEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var content: String?

}

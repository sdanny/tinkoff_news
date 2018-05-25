//
//  NewsItemEntity+CoreDataProperties.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 23.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//
//

import Foundation
import CoreData


extension NewsItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsItemEntity> {
        return NSFetchRequest<NewsItemEntity>(entityName: "NewsItemEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var text: String?
    @NSManaged public var publicationDate: NSDate?

}

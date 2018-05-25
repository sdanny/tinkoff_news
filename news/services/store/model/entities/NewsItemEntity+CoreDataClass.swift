//
//  NewsItemEntity+CoreDataClass.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 23.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//
//

import Foundation
import CoreData

public class NewsItemEntity: NSManagedObject {
    
    func update(from item: NewsItem) {
        self.id = item.id
        self.name = item.name
        self.text = item.text
        self.publicationDate = NSDate(timeIntervalSinceReferenceDate:
            item.publicationDate.timeIntervalSinceReferenceDate)
    }
    
    var item: NewsItem? {
        guard let id = id,
            let name = name,
            let text = text,
            let publicationDate = publicationDate as? Date else { return nil }
        return NewsItem(id: id, name: name, text: text, publicationDate: publicationDate)
    }
}

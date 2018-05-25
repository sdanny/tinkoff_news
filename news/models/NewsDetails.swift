//
//  NewsDetails.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

struct NewsDetails: DictDecodable {
    
    private enum Key: String {
        case item = "title"
        case creationDate, lastModificationDate, content, milliseconds
    }
    
    let item: NewsItem
    let creationDate: Date
    let lastModificationDate: Date
    let content: String
    
    init(item: NewsItem, creationDate: Date, lastModificationDate: Date, content: String) {
        self.item = item
        self.creationDate = creationDate
        self.lastModificationDate = lastModificationDate
        self.content = content
    }
    
    init?(dict: [String : AnyObject]) {
        guard let itemDict = dict[Key.item.rawValue] as? [String: AnyObject],
            let item = NewsItem(dict: itemDict),
            let creationDict = dict[Key.creationDate.rawValue] as? [String: AnyObject],
            let creationValue = creationDict[Key.milliseconds.rawValue] as? Double,
            let lastModificationDict = dict[Key.lastModificationDate.rawValue] as? [String: AnyObject],
            let lastModificationValue = lastModificationDict[Key.milliseconds.rawValue] as? Double,
            let content = dict[Key.content.rawValue] as? String else { return nil }
        let creationDate = Date(timeIntervalSinceReferenceDate: creationValue)
        let lastModificationDate = Date(timeIntervalSinceReferenceDate: lastModificationValue)
        self.init(item: item, creationDate: creationDate, lastModificationDate: lastModificationDate, content: content)
    }
}

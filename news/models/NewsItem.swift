//
//  NewsItem.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

struct NewsItem: DictDecodable {
    
    private enum Key: String {
        case id, name, text, publicationDate, milliseconds
    }
    
    let id: String
    let name: String
    let text: String
    let publicationDate: Date
    
    init(id: String, name: String, text: String, publicationDate: Date) {
        self.id = id
        self.name = name
        self.text = text
        self.publicationDate = publicationDate
    }
    
    init?(dict: [String: AnyObject]) {
        guard let id = dict[Key.id.rawValue] as? String,
            let name = dict[Key.name.rawValue] as? String,
            let text = dict[Key.text.rawValue] as? String,
            let publicationDict = dict[Key.publicationDate.rawValue] as? [String: Double],
            let publicationValue = publicationDict[Key.milliseconds.rawValue] else { return nil }
        let publicationDate = Date(timeIntervalSinceReferenceDate: publicationValue)
        self.init(id: id, name: name, text: text, publicationDate: publicationDate)
    }
}

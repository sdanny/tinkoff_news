//
//  CountEntity+CoreDataProperties.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 23.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//
//

import Foundation
import CoreData


extension CountEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountEntity> {
        return NSFetchRequest<CountEntity>(entityName: "CountEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var value: Int16

}

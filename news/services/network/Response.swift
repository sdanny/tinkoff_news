//
//  Response.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 21.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

enum Response<Value> {
    case success(Value)
    case failure(Error)
}

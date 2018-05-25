//
//  DetailsModuleInOut.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright (c) 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

protocol DetailsModuleInput: ViperModuleInput {
    func configure(itemId: String)
}

protocol DetailsModuleOutput: ViperModuleOutput {
    
}

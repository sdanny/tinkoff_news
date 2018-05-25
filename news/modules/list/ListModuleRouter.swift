//
//  ListModuleRouter.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright (c) 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

class ListModuleRouter: ListModuleRouterInput {
    
    var transitionHandler: ViperModuleTransitionHandler!
    var detailsModuleFactory: ViperModuleFactoryProtocol!
    
    // MARK: input methods
    func openDetailsModule(itemId: String) {
        transitionHandler.pushModule(factory: detailsModuleFactory, animated: true)
            .thenChain { (input) -> ViperModuleOutput? in
            if let input = input as? DetailsModuleInput {
                input.configure(itemId: itemId)
            }
            return nil
        }
    }
}

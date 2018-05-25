//
//  DetailsModuleRouter.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

protocol URLOpener {
    func canOpenURL(_ url: URL) -> Bool
    func openURL(_ url: URL)
}

class DetailsModuleRouter: DetailsModuleRouterInput {
    
    var transitionHandler: ViperModuleTransitionHandler!
    var urlOpener: URLOpener!
    
    func closeAnimated() {
        transitionHandler.closeModule(animated: true)
    }
    
    func canOpenURL(_ url: URL) -> Bool {
        return urlOpener.canOpenURL(url)
    }
    
    func openURL(_ url: URL) {
        urlOpener.openURL(url)
    }
}

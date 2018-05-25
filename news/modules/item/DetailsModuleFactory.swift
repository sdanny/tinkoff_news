//
//  DetailsModuleFactory.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 22.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

class DetailsModuleFactory: ViperModuleFactoryProtocol {
    
    func instantiateModuleTransitionHandler() -> ViperModuleTransitionHandler {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailsModuleView") as! DetailsModuleView
        controller.loadViewIfNeeded()
        
        let router = DetailsModuleRouter()
        router.transitionHandler = controller
        router.urlOpener = UIApplication.shared
        
        let provider = StoreBaseContextProvider.withObjectModel(named: "Model")
        let cacheStoreBase = ContentCacheStoreBase(provider: provider)
        
        let interactor = DetailsModuleInteractor()
        interactor.loader = HTTPClient.shared
        interactor.cache = ContentCache(storeBase: cacheStoreBase)
        
        let presenter = DetailsModulePresenter()
        presenter.view = controller
        presenter.interactor = interactor
        presenter.router = router
        
        controller.output = presenter
        controller.moduleInput = presenter
        
        return controller
    }
}

extension UIApplication: URLOpener {
    func openURL(_ url: URL) {
        open(url, options: [:], completionHandler: nil)
    }
}

//
//  ListModuleFactory.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 21.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

class ListModuleFactory: ViperModuleFactoryProtocol {
    
    private struct Constant {
        static let controllerId = "ListModuleView"
    }
    
    func instantiateModuleTransitionHandler() -> ViperModuleTransitionHandler {
        return instantiateController()
    }
    
    func instantiateController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Constant.controllerId) as! ListModuleView
        controller.loadViewIfNeeded()
        
        let router = ListModuleRouter()
        router.transitionHandler = controller
        router.detailsModuleFactory = DetailsModuleFactory()
        
        let provider = StoreBaseContextProvider.withObjectModel(named: "Model")
        let itemsCacheStoreBase = ItemsCacheStoreBase(provider: provider)
        let counterStoreBase = ItemsListCounterStoreBase(provider: provider)
        
        let interactor = ListModuleInteractor()
        interactor.loader = HTTPClient.shared
        interactor.cache = ItemsCache(storeBase: itemsCacheStoreBase)
        interactor.counter = ItemsListCounter(storeBase: counterStoreBase)
        
        let presenter = ListModulePresenter()
        presenter.view = controller
        presenter.interactor = interactor
        presenter.router = router
        
        controller.output = presenter
        controller.moduleInput = presenter
        
        return controller
    }
}

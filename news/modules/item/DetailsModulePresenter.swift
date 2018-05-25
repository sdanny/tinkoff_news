//
//  DetailsModulePresenter.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright (c) 2018 Daniyar Salakhutdinov. All rights reserved.
//
//

import UIKit

protocol DetailsModuleViewInput: class, ErrorPresenterProtocol {
    func presentActivityIndicator(text: String)
    func dismissActivityIndicator()
    
    func setContent(_ content: String)
}

protocol DetailsModuleInteractorInput {
    func cachedContent(itemId: String) -> String?
    func setContent(_ content: String, ofItem itemId: String)
    
    func loadDetails(itemId: String, completion: @escaping (Response<NewsDetails>) -> Void)
}

protocol DetailsModuleRouterInput: URLOpener {
    func closeAnimated()
}

class DetailsModulePresenter: DetailsModuleInput, DetailsModuleViewOutput {
    
    weak var view: DetailsModuleViewInput?
    var interactor: DetailsModuleInteractorInput!
    var router: DetailsModuleRouterInput!
    weak var moduleOutput: ViperModuleOutput?
    
    private var details: NewsDetails?
  
    // MARK: module input methods
    func configure(itemId: String) {
        var indicating = true
        if let content = interactor.cachedContent(itemId: itemId) {
            setContent(content)
            indicating = false
        }
        reloadContent(itemId: itemId, indicating: indicating)
    }
    
    private func reloadContent(itemId: String, indicating: Bool) {
        if indicating {
            view?.presentActivityIndicator(text: "Загрузка деталей")
        }
        interactor.loadDetails(itemId: itemId) { [weak self] (response) in
            guard let `self` = self else { return }
            self.view?.dismissActivityIndicator()
            // check the response
            switch response {
            case .failure(let error):
                self.view?.presentErrorAlert(title: "\(error)", repeatHandler: {
                    self.reloadContent(itemId: itemId, indicating: indicating)
                }, cancelHandler: {
                    self.router.closeAnimated()
                })
            case .success(let details):
                self.interactor.setContent(details.content, ofItem: itemId)
                self.updateUI(details: details)
            }
        }
    }
    
    private func setContent(_ content: String) {
        let document = "<!DOCTYPE html><html><body><font size=\"18\">\(content)</font></body></html>"
        view?.setContent(document)
    }
    
    private func updateUI(details: NewsDetails) {
        self.details = details
        setContent(details.content)
    }
    
    // MARK: view output
    func shouldAllowNavigating(to url: URL?) -> Bool {
        guard let url = url else { return false }
        if router.canOpenURL(url) {
            router.openURL(url)
            return false
        } else {
            return true
        }
    }
    
}

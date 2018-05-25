//
//  ListModulePresenter.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright (c) 2018 Daniyar Salakhutdinov. All rights reserved.
//
//

import UIKit

struct ListModuleNewsItemCellModel {
    let id: String
    let title: String
    let text: String
}

protocol ListModuleViewInput: class, ErrorPresenterProtocol {
    func presentActivityIndicator()
    func dismissActivityIndicator()
    func startRefreshing()
    func stopRefreshing()
    
    func appendModels(_ models: [ListModuleNewsItemCellModel])
    func removeAll()
    
    func reloadData()
}

protocol ListModuleInteractorInput {
    
    func load(page: Int, completion: @escaping (Response<(items: [NewsItem], stop: Bool)>) -> Void)
    
    var cachedItems: [NewsItem] { get }
    
    func counterValue(forItemId itemId: String) -> Int
    func incrementCounterValue(forItemId itemId: String)
}

protocol ListModuleRouterInput {
    func openDetailsModule(itemId: String)
}

class ListModulePresenter: ListModuleInput, ListModuleViewOutput {
    
    weak var view: ListModuleViewInput?
    var interactor: ListModuleInteractorInput!
    var router: ListModuleRouterInput!
    weak var moduleOutput: ViperModuleOutput?
  
    private var isStopped = false
    private var isLoading = false
    private let lock = NSLock()
    private var page = 0
    
    // MARK: module input methods
    func configure() {
        let items = interactor.cachedItems.sorted { $0.publicationDate > $1.publicationDate }
        let models = createModels(from: items)
        view?.appendModels(models)
        refreshFirstPage()
    }
    
    func refreshFirstPage() {
        view?.startRefreshing()
        setIsLoadingSafely(true)
        interactor.load(page: 0) { [weak self] (response) in
            guard let `self` = self else { return }
            self.view?.stopRefreshing()
            self.setIsLoadingSafely(false)
            switch response {
            case .failure(let error):
                self.view?.presentErrorAlert(title: String(describing: error), repeatHandler: {
                    self.refreshFirstPage()
                }, cancelHandler: {
                    self.isStopped = true
                })
            case .success(let result):
                self.page = 0
                self.isStopped = result.stop
                self.view?.removeAll()
                let models = self.createModels(from: result.items)
                self.view?.appendModels(models)
            }
        }
    }
    
    private func createModels(from items: [NewsItem]) -> [ListModuleNewsItemCellModel] {
        return items.map { ListModuleNewsItemCellModel(id: $0.id, title: $0.name, text: $0.text) }
    }
    
    // MARK: view output methods
    func viewWillAppear() {
        view?.reloadData()
    }
    
    func didReachBottom() {
        loadNextPage()
    }
    
    private func loadNextPage() {
        guard !isLoading,
            !isStopped else { return }
        let newPage = page + 1
        setIsLoadingSafely(true)
        view?.presentActivityIndicator()
        interactor.load(page: newPage) { [weak self] (response) in
            guard let `self` = self else { return }
            self.view?.dismissActivityIndicator()
            switch response {
            case .failure(let error):
                self.view?.presentErrorAlert(title: String(describing: error), repeatHandler: {
                    self.setIsLoadingSafely(false)
                    self.loadNextPage()
                }, cancelHandler: {
                    self.setIsLoadingSafely(false)
                    self.setIsStoppedSafely(true)
                })
            case .success(let result):
                self.page = newPage
                self.setIsStoppedSafely(result.stop)
                let models = self.createModels(from: result.items)
                self.view?.appendModels(models)
                self.setIsLoadingSafely(false)
            }
        }
    }
    
    private func setIsLoadingSafely(_ isLoading: Bool) {
        lock.lock()
        self.isLoading = isLoading
        lock.unlock()
    }
    
    private func setIsStoppedSafely(_ isStopped: Bool) {
        lock.lock()
        self.isStopped = isStopped
        lock.unlock()
    }
    
    func didSelectItem(id: String) {
        router.openDetailsModule(itemId: id)
        interactor.incrementCounterValue(forItemId: id)
    }
    
    func didRefresh() {
        refreshFirstPage()
    }
    
    func counterValue(ofItemWithId id: String) -> String {
        return String(describing: interactor.counterValue(forItemId: id))
    }
    
}

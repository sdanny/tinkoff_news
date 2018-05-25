//
//  ListModuleView.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright (c) 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

protocol ListModuleViewOutput {
    func viewWillAppear()
    func didReachBottom()
    func didSelectItem(id: String)
    func didRefresh()
    
    func counterValue(ofItemWithId id: String) -> String
}

class ListModuleView: UIViewController, ListModuleViewInput, TableManagerConfigurer, TableManagerDelegate {
    
    private struct Constant {
        static let cellReuseIdentifier = "Cell"
    }
    
    var output: ListModuleViewOutput!
    
    @IBOutlet private var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    private var manager: TableManager!
    private var models = [ListModuleNewsItemCellModel]()
    
    // MARK: view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // adding refresh control with a tricky way
        let controller = UITableViewController(style: .plain)
        controller.tableView = tableView
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlDidPull(_:)), for: .valueChanged)
        controller.refreshControl = refreshControl
        
        manager = TableManager(table: tableView, identifier: Constant.cellReuseIdentifier)
        manager.delegate = self
        manager.configurer = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    // MARK: input methods
    func presentActivityIndicator() {
        manager.startLoading()
    }
    
    func dismissActivityIndicator() {
        manager.stopLoading()
    }
    
    func startRefreshing() {
        refreshControl.beginRefreshing()
    }
    
    func stopRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func appendModels(_ models: [ListModuleNewsItemCellModel]) {
        self.models.append(contentsOf: models)
        manager.append(rows: models.count)
    }
    
    func removeAll() {
        models = []
        manager.removeAll()
    }
    
    func reloadData() {
        for index in 0..<models.count {
            manager.reloadCell(at: index)
        }
    }
    
    // MARK: table manager configurer
    func configure(manager: TableManager, cell: UITableViewCell, at index: Int) {
        guard let cell = cell as? ListModuleNewsItemCell else { return }
        let model = models[index]
        cell.titleLabel.text = model.title
        cell.descriptionLabel.text = model.text
        cell.counterLabel.text = output.counterValue(ofItemWithId: model.id)
    }
    
    // MARK: table manager delegate
    func tableManager(_ manager: TableManager, didSelectItemAt index: Int) {
        output.didSelectItem(id: models[index].id)
    }
    
    func tableManagerDidReachBottom(_ manager: TableManager) {
        output.didReachBottom()
    }
    
    // MARK: actions
    @objc
    func refreshControlDidPull(_ sender: Any) {
        output.didRefresh()
    }
    
}

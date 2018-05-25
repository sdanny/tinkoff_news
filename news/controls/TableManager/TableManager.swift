//
//  TableManager.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

protocol TableManagerConfigurer: NSObjectProtocol {
    func configure(manager: TableManager, cell: UITableViewCell, at index: Int)
}

protocol TableManagerDelegate: NSObjectProtocol {
    
    func tableManager(_ manager: TableManager, didSelectItemAt index: Int)
    func tableManagerDidReachBottom(_ manager: TableManager)
}

class TableManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private struct Constants {
        static let loadingCellReuseIdentifier = "LoadingCell"
        static let scrollingBottomInsets: CGFloat = 30
    }
    
    let table: TableConvertible
    weak var configurer: TableManagerConfigurer?
    weak var delegate: TableManagerDelegate?
    
    fileprivate var itemsCount = 0
    fileprivate(set) var isLoading = false
    fileprivate let lock = NSLock()
    fileprivate let identifier: String
    
    init(table: TableConvertible, identifier: String) {
        self.table = table
        self.identifier = identifier
        let nib = UINib(nibName: Constants.loadingCellReuseIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: Constants.loadingCellReuseIdentifier)
        super.init()
        table.dataSource = self
        table.delegate = self
    }
    
    func beginUpdates() {
        table.beginUpdates()
    }
    
    func endUpdates() {
        table.endUpdates()
    }
    
    func remove(at index: Int, animated: Bool) {
        itemsCount -= 1
        table.reloadData()
    }
    
    func removeAll() {
        lock.lock()
        itemsCount = 0
        lock.unlock()
        table.reloadData()
    }
    
    func insert(rows: Int, at: Int) {
        guard rows > 0 else { return }
        lock.lock()
        var paths = [IndexPath]()
        for index in at..<(at + rows) {
            let path = IndexPath(row: index, section: 0)
            paths.append(path)
        }
        itemsCount += rows
        lock.unlock()
        table.reloadData()
    }
    
    func append(rows: Int) {
        insert(rows: rows, at: itemsCount)
    }
    
    func cellAtIndex(_ index: Int) -> UITableViewCell? {
        let path = IndexPath(row: index, section: 0)
        return table.cellForRow(at: path)
    }
    
    func startLoading() {
        // synchronize
        lock.lock()
        guard !isLoading else {
            lock.unlock()
            return
        }
        // set flag
        isLoading = true
        lock.unlock()
        table.reloadData()
    }
    
    func stopLoading() {
        // synchronize
        lock.lock()
        guard isLoading else {
            lock.unlock()
            return
        }
        // set flag
        isLoading = false
        lock.unlock()
        table.reloadData()
    }
    
    func reloadCell(at index: Int) {
        guard let cell = cellAtIndex(index) else { return }
        configurer?.configure(manager: self, cell: cell, at: index)
    }
    
    // MARK: table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return itemsCount + 1
        } else {
            return itemsCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading && indexPath.row == itemsCount {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            cell.indicator.startAnimating()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            configurer?.configure(manager: self, cell: cell, at: indexPath.row)
            return cell
        }
    }
    
    // MARK: table view delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.tableManager(self, didSelectItemAt: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoading,
            itemsCount > 0 else { return }
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= (scrollView.contentSize.height - Constants.scrollingBottomInsets) {
            delegate?.tableManagerDidReachBottom(self)
        }
    }
}

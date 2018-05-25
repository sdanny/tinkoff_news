//
//  TableConvertible.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 21.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

protocol TableConvertible: NSObjectProtocol {
    var dataSource: UITableViewDataSource? { get set }
    var delegate: UITableViewDelegate? { get set }
    
    var contentSize: CGSize { get set }
    var contentOffset: CGPoint { get set }
    var bounds: CGRect { get }
    
    func sizeThatFits(_ size: CGSize) -> CGSize
    
    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String)
    
    func beginUpdates()
    func endUpdates()
    
    func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell?
    
    func reloadData()
}

extension UITableView: TableConvertible {}

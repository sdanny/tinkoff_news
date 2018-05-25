//
//  NibLoader.swift
//  WiseWallet
//
//  Created by Ilnur Yagudin on 18/02/16.
//  Copyright © 2016 Moneta.ru. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     Creates a new instance of the class on which this method is invoked,
     instantiated from a nib of the given name. If no nib name is given
     then a nib with the name of the class is used.
     
     - parameter nibNameOrNil: The name of the nib to instantiate from, or
     nil to indicate the nib with the name of the class should be used.
     
     - returns: A new instance of the class, loaded from a nib.
     */
    static func loadFromNib(name: String? = nil) -> UIView {
        let nibName = name ?? String(describing: self)
        let nib = UINib(nibName: nibName, bundle: nil)
        let item = nib.instantiate(withOwner: nil, options: nil).first as! UIView
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }
}

protocol ViewContainer {
    
    func addSubview(_ view: UIView)
}

extension UIView: ViewContainer { }

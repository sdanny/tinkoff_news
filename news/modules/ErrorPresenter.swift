//
//  ErrorPresenter.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 23.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

protocol ErrorPresenterProtocol {
    func presentErrorAlert(title: String,
                           repeatHandler: @escaping ViperModuleClosure,
                           cancelHandler: @escaping ViperModuleClosure)
}

extension ErrorPresenterProtocol where Self: UIViewController {
    
    func presentErrorAlert(title: String,
                           repeatHandler: @escaping ViperModuleClosure,
                           cancelHandler: @escaping ViperModuleClosure) {
        let alert = UIAlertController(title: "Ошибка", message: title, preferredStyle: .alert)
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            repeatHandler()
        }
        let cancelAction = UIAlertAction(title: "Скрыть", style: .cancel) { _ in
            cancelHandler()
        }
        alert.addAction(repeatAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

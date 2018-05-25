//
//  Error.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 21.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import Foundation

enum Error: Swift.Error, CustomStringConvertible {
    case noInternet
    case invalidResponse
    case requestTimeout
    case other(Swift.Error)
    
    var description: String {
        switch self {
        case .invalidResponse:
            return "Неверный ответ"
        case .noInternet:
            return "Отсутствует соединение с Интернет"
        case .requestTimeout:
            return "Превышен лимит времени ожидания запроса"
        case .other(let error):
            return String(describing: error)
        }
    }
}

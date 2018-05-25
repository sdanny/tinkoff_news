//
//  ModuleInput.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import Foundation

protocol ViperModuleAssembly {
    
    func setup()
}

/// Based on Rambler Viper architecture
protocol ViperModuleInput : class {
    
    var moduleOutput: ViperModuleOutput? { get set }
}

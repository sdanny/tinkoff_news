//
//  RequestHelper.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

class RequestHelper: RequestHelperProtocol {
    
    let baseUrl: URL
    let reachability: ReachabilityProtocol
    let session: URLSession
    
    init(baseUrl: URL, reachability: ReachabilityProtocol) {
        self.baseUrl = baseUrl
        self.reachability = reachability
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        self.session = URLSession(configuration: configuration)
    }
    
    func get(path: String, completion: @escaping (Response<Any>) -> Void) {
        guard let url = URL(string: path, relativeTo: baseUrl) else { fatalError() }
        guard reachability.isConnectedToNetwork() else {
            completion(.failure(.noInternet))
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: [])
                    DispatchQueue.main.async {
                        completion(.success(object))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.other(error)))
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
            }
        }
        task.resume()
    }
    
}

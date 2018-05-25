//
//  HTTPClient.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit

protocol DictDecodable {
    init?(dict: [String: AnyObject])
}

protocol RequestHelperProtocol {
    func get(path: String, completion: @escaping (Response<Any>) -> Void)
}

class HTTPClient: ItemsListLoaderProtocol, DetailsLoaderProtocol {
    
    private struct Constant {
        static let baseUrl = URL(string: "https://api.tinkoff.ru/v1/")!
    }
    
    static var shared: HTTPClient = {
        let helper = RequestHelper(baseUrl: Constant.baseUrl, reachability: Reachability())
        return HTTPClient(helper: helper, pageSize: 10)
    }()
    
    let helper: RequestHelperProtocol
    let pageSize: Int
    
    init(helper: RequestHelperProtocol, pageSize: Int) {
        self.helper = helper
        self.pageSize = pageSize
    }
    
    func loadItems(at page: Int, completion: @escaping (Response<(items: [NewsItem], stop: Bool)>) -> Void) {
        let first = page * pageSize
        let last = first + pageSize
        helper.get(path: "news?first=\(first)&last=\(last)") { (response) in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let object):
                guard let dict = object as? [String: AnyObject],
                    let payload = dict["payload"] as? [AnyObject] else {
                    completion(.failure(.invalidResponse))
                    return
                }
                var items = [NewsItem]()
                var invalids = 0
                for object in payload {
                    guard let itemDict = object as? [String: AnyObject],
                        let item = NewsItem(dict: itemDict) else {
                            invalids += 1
                            print("Could not deserialize object: \(object)")
                            continue
                    }
                    items.append(item)
                }
                let result = (items: items, stop: (items.count + invalids < self.pageSize))
                completion(.success(result))
            }
        }
    }
    
    func loadDetails(id: String, completion: @escaping (Response<NewsDetails>) -> Void) {
        helper.get(path: "news_content?id=\(id)") { (response) in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let object):
                guard let dict = object as? [String: AnyObject],
                    let payload = dict["payload"] as? [String: AnyObject],
                    let details = NewsDetails(dict: payload) else {
                        completion(.failure(.invalidResponse))
                        return
                }
                completion(.success(details))
            }
        }
    }
}

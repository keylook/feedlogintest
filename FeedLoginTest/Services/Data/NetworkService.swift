//
//  NetworkService.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 5/20/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import Foundation

enum NetworkServiceError: Error {
    case NoDataInResponse
}

/// A basic implementation of a Networking
/// Extended to concrete implementation via protocols
class NetworkService {
    
    private var client: NetworkClient
    private var cacheService: CacheService
    private let isCachingEnabled: Bool
    
    init(enableCache: Bool) {
        client = NetworkClient()
        cacheService = CacheService()
        isCachingEnabled = enableCache
    }
    
    private func cacheResponse(data: Data?, key: CacheKey) {
        if isCachingEnabled, let data = data {
            cacheService.setObjectToCache(key: key, data: data)
        }
    }
}


protocol ArticleService {
    /// Depending on implementation retrieves a list of articles and handles errors if any
    func getArticles(result: @escaping (_ articles: [Article]?, _ error: Error?) -> Void)
}

extension NetworkService: ArticleService {
    
    
    func getArticles(result: @escaping ([Article]?, Error?) -> Void) {
        
        client.load(method: .get, path: Api.getHeadLines()) { (data, error) in
            guard let data = data else {
                result(nil, NetworkServiceError.NoDataInResponse)
                return
            }
            
            do {
                let res = try JSONDecoder().decode(ArticleResponse.self, from: data)
                result(res.articles, nil)
            } catch {
                result(nil, error)
            }
    
            defer {
                self.cacheResponse(data: data, key: CacheKey.articles)
            }
            
        }

    }
    
   
    
}

        




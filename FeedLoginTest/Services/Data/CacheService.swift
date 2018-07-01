//
//  CacheService.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 5/21/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import Foundation

enum CacheKey: String {
    case articles = "cachedArticles"
}

enum CacheServiceError: Error {
    case NoDataForKey
}

/// For the sake of speed and simplicity `CacheService` implements retrieving and saving to `UserDefault`s.
/// In a production enviornment this implementation could be easily swapped in favour of any other storage solution.
class CacheService {

    private var localCache: UserDefaults
    
    init() {
        localCache = UserDefaults.standard
    }
    
    func getObjectFromCache(key: CacheKey) -> Data? {
        return localCache.data(forKey: key.rawValue)
    }
    
    func setObjectToCache(key: CacheKey, data: Data) {
        localCache.set(data, forKey: key.rawValue)
    }
    
}

extension CacheService: ArticleService {
    
    func getArticles(result: @escaping ([Article]?, Error?) -> Void) {
        guard let data = self.getObjectFromCache(key: CacheKey.articles) else {
            result(nil, CacheServiceError.NoDataForKey)
            return
        }
        
        do {
            let articles = try JSONDecoder().decode([Article].self, from: data)
            result(articles, nil)
        } catch {
            result(nil, error)
        }

    }
    
    
    
    
    
}

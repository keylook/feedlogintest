//
// NetworkService.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 5/20/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}


struct Credentials {
    static let apiKEY: String = "cf8ef8e8a8d84036bb86b04b1fba87b9"
}

struct NewsApiEndpoints {
    static let headlines = "https://newsapi.org/v2/top-headlines"
}

struct Api {
    
    static func getHeadLines(country: String = "us", category: String = "business") -> String {
        return "\(NewsApiEndpoints.headlines)?country=\(country)&category=\(category)&apiKey=\(Credentials.apiKEY)"
    }
}



enum NetworkError: Error {
    case BadResponse(code: Int)
    case NoNetwork()
}



class NetworkClient {
    
    /// The main method for loading content from the Web, responding with data or error objects
    /// - parameter method: an HTTPMethod pass into request. (GET, POST, DELETE, PUT)
    /// - parameter path: a string representing a request url
    /// - parameter completion: a callback that will be exectued upon a completion of a load request. May return `Data` or `Error`
    /// - parameter data: the result of a data task, may be `nil`
    /// - parameter error: the error, if something during the process of request when wrong described in `NetworkError`, may be `nil`
    
    func load(method: HTTPMethod, path: String, completion: @escaping(_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: path) else  { return }
    
        let session = URLSession.shared
        var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completion(nil, NetworkError.BadResponse(code: response.statusCode))
                } else {
                    completion(data, error)
                }
            }
        }

        task.resume()
        
    }
    
    
    
    /// The main method for loading content from the Web, responding with data or error objects
    /// - parameter url: a link to image to load
    /// - parameter completion: a callback that will be exectued upon a completion of a load request. May return `Data` or `Error`
    /// - parameter imageData: the result of a data task, may be `nil`
    /// - parameter error: the error, if something during the process of request when wrong described in `NetworkError`, may be `nil`
    
    func loadImage(url: String, completion: @escaping(_ imageData: Data?, _ error: Error?) -> Void) {
        guard let imageUrl = URL(string: url) else { return }
        let request = URLRequest(url: imageUrl, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 3)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                completion(data, nil)
            } else {
                completion(nil, error)
            }
        }
    
        task.resume()
        
    }
    
    
}

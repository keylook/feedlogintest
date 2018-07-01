//
//  Models.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 5/20/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import Foundation

struct ArticleResponse: Decodable {
    var articles: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case articles
    }
}

struct Article: Decodable {
    var source: Source
    var author: String?
    var title: String
    var description: String?
    var url: String
    var imageUrl: String?
    var publishedAt: String
    
    var strHash: String {
        return String(title.hashValue)
    }
    
    private enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case imageUrl = "urlToImage"
        case publishedAt
    }

    func getPublishDate() -> String {
        let split = publishedAt.split(separator: "T")
        let date = split[0].replacingOccurrences(of: "-", with: ".")
        return date
    }
    
}

struct Source: Decodable {
    var id: String?
    var name: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
}


/// VK Model
struct UserProfile: Decodable {
    let name: String
    let imageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "first_name"
        case imageURL = "photo_100"
    }
    
}



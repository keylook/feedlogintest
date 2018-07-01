//
//  VKApiService.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 6/30/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import Foundation
import SwiftyVK

class VKApiService {

    typealias UserProfileCompletionHandler = (_ profile: UserProfile?, _ error: Error?) -> ()
    
    private var isConfigured = false
    
    private func configure() {
        VK.sessions.default.config.attemptsPerSecLimit = 1
        VK.sessions.default.config.attemptsMaxLimit = 3
        isConfigured = true
    }
    
    public func getUserInfo(userID: String, completion: @escaping UserProfileCompletionHandler) {
        
        if !isConfigured {
            configure()
        }
        
        let params: Parameters = [.userIDs: userID,
                                  .fields: "photo_100"]
    
        VK.API.Users.get(params)
            .onSuccess { data in
                do {
                    let userInfo = try JSONDecoder().decode([UserProfile].self, from: data)
                    completion(userInfo.first, nil)
                } catch {
                    completion(nil, error)
                }
            }
            
            .onError { error in
                completion(nil, error)
            }
            
            .send()
        
    }
    
    

    
    
}

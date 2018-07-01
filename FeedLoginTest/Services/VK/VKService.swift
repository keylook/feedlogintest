//
//  VKService.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 6/30/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import Foundation
import SwiftyVK


final class VKService {
    public static let shared = VKService()
    
    private let vkApplicationID: String = "6620409"
    private var scopes: Scopes = [.photos, .offline]
    private let apiService: VKApiService
    
    private var userProfile: UserProfile? 
    
    private init() {
        apiService = VKApiService()
        VK.setUp(appId: vkApplicationID, delegate: self)
    }
    
    public func login(onSuccess: @escaping ([String: String]) ->(), onError: @escaping (Error) -> () ) {
        
        VK.sessions.default.logIn(
            onSuccess: { info in onSuccess(info) },
            onError: { error in onError(error) })
    
    }
    
    
    public func logout() {
        VK.sessions.default.logOut()
        Storage.vkToken = nil
        Storage.vkUserID = nil
    }
    
    
    public func getVKUser() {
        guard let userID = Storage.vkUserID else { return }
        apiService.getUserInfo(userID: userID, completion: { profile, error in
            if let profile = profile {
                self.userProfile = profile
            }
        })
    }
    
    
    public func getProfile() -> UserProfile? {
        return userProfile
    }
    
    
}


extension VKService: SwiftyVKDelegate {
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        // Called when SwiftyVK attempts to get access to user account
        // Should return a set of permission scopes
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        // Called when SwiftyVK wants to present UI (e.g. webView or captcha)
        // Should display given view controller from current top view controller
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            rootVC.present(viewController, animated: true, completion: nil)
        }
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        // Called when user grants access and SwiftyVK gets new session token
        // Can be used to run SwiftyVK requests and save session data
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        // Called when existing session token has expired and successfully refreshed
        // You don't need to do anything special here
    }
    
    func vkTokenRemoved(for sessionId: String) {
        // Called when user was logged out
        // Use this method to cancel all SwiftyVK requests and remove session data
    }
    
}

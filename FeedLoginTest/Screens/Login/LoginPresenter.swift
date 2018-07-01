//
//  LoginPresenter.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 6/30/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import Foundation
import SwiftyVK

protocol LoginPresenterDelegate: class {
    func onLoginSuccess()
    func onLoginError(_ error: Error)
}

class LoginPresenter {
    
    private weak var delegate: LoginPresenterDelegate?
    private var navigationListener: Navigatable?
    
    init(delegate: LoginPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func listenToNavigation(_ listener: Navigatable) {
        navigationListener = listener
    }
    
    
    public func loginWithVK() {
        
        guard Storage.vkToken == nil else {
            showFeed()
            return
        }
        
        VKService.shared.login(
            onSuccess: { info in self.handleSuccessfulLogin(info: info) },
            onError: {error in self.delegate?.onLoginError(error) }
        )
    }
    
    public func showFeed() {
        VKService.shared.getVKUser()
        DispatchQueue.main.async {
            Navigator.shared.saveStackFor(key: loginStackKey, controller: (self.delegate as! LoginViewController))
            self.navigationListener?.switchTo(viewControllerID: "FeedNavigationControllerID")
        }
    }
    
    
    private func handleSuccessfulLogin(info: [String: String]) {
        Storage.vkUserID = info["user_id"]
        Storage.vkToken = info["access_token"]
        delegate?.onLoginSuccess()
    }
    
    
}

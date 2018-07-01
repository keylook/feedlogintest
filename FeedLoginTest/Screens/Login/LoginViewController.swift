//
//  LoginViewController.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 6/30/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import UIKit
import SwiftyVK

class LoginViewController: UIViewController, Navigatable, Alertable {
    
    @IBOutlet weak var vkLoginButton: UIButton!
    private var presenter: LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = LoginPresenter(delegate: self)
        presenter.listenToNavigation(self)
        setupVkLogin()
    }
    
    private func setupVkLogin() {
        vkLoginButton.layer.cornerRadius = 10
        vkLoginButton.layer.borderWidth = 1
        vkLoginButton.layer.borderColor = UIColor.white.cgColor
        vkLoginButton.addTarget(self, action: #selector(vkTapped), for: .touchUpInside)
    }
    
    @objc private func vkTapped() {
        presenter.loginWithVK()
    }
    
    
}

extension LoginViewController: LoginPresenterDelegate {
    
    func onLoginSuccess() {
        presenter.showFeed()
    }
    
    func onLoginError(_ error: Error) {
        presentAlertWith(error: error)
    }
}






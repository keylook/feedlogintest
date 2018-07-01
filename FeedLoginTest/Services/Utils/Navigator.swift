//
//  Navigator.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 6/30/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import UIKit

protocol Navigatable {
    func viewController(with identifier: String) -> UIViewController?
    
    func navigateTo(viewController: UIViewController, modally: Bool)
    
    func switchTo(viewController: UIViewController)
    func switchTo(viewControllerID: String)
}

extension Navigatable where Self: UIViewController {
    
    func viewController(with identifier: String) -> UIViewController? {
        return storyboard?.instantiateViewController(withIdentifier: identifier)
    }

    func navigateTo(viewController: UIViewController, modally: Bool) {
        if modally {
            navigationController?.present(viewController, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    

    func switchTo(viewController: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    func switchTo(viewControllerID: String) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: viewControllerID) else { return }
        switchTo(viewController: vc)
    }
    
}


public typealias StackKey = String
public let loginStackKey: String = "LoginStack"
public let feedStackKey: String = "FeedStack"

final class Navigator {
    public static let shared = Navigator()
    private init() {}
    
    private var navigationStacks: [String: UIViewController] = [:]
    
    public func saveStackFor(key: StackKey, controller: UIViewController) {
        navigationStacks[key] = controller
    }
    
    public func restoreStackWith(key: StackKey) -> UIViewController? {
        return navigationStacks[key]
    }
    
}




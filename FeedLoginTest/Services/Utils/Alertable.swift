//
//  Alertable.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 6/30/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import UIKit

protocol Alertable {
    func presentAlertWith(error: Error)
}

extension Alertable where Self: UIViewController {
    func presentAlertWith(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .cancel) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
    }
}

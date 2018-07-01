//
//  StatusView.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 5/20/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import UIKit

enum StatusViewColor: String {
    case connected = "#91DC00"
    case offline = "#DC3800"
}


@IBDesignable
class StatusView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customLayout()
    }
    
    
    lazy var statusLabel: UILabel = UILabel()
    
    private func customLayout() {
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        statusLabel.textColor = UIColor.white
        statusLabel.textAlignment = .center
        statusLabel.frame = bounds
        addSubview(statusLabel)
    }
    
    
    func setStatus(_ status: StatusViewColor, animated: Bool) {
        
        if animated {
            UIView.animate(withDuration: 0.33) {
                self.backgroundColor = hexColor(hex: status.rawValue)
            }
        } else {
            self.backgroundColor = hexColor(hex: status.rawValue)
        }
        
        statusLabel.text = (status == .connected) ? "Online": "Offline mode"
        
    }
}

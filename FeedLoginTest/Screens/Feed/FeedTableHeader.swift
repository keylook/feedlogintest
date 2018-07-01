//
//  FeedTableHeader.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 6/30/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import UIKit

class FeedTableHeader: UITableViewHeaderFooterView {
    
    var avatar: UIImageView!
    var name: UILabel!
    private var overlay: UIView!
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func layout() {
        
        avatar = UIImageView(frame: CGRect(x: 12, y: 16, width: 50, height: 50))
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.contentMode = .scaleAspectFit
        avatar.backgroundColor = hexColor(hex: "#002E60")
        addSubview(avatar)
        
        name = UILabel(frame: CGRect(x: avatar.frame.maxY + 8, y: avatar.frame.midY - 7, width: 150, height: 14))
        name.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        name.textColor = hexColor(hex: "#002E60")
        addSubview(name)
        
    }
    
    
    public func updateWith(profile: UserProfile) {
        //overlay.frame = bounds
        name.text = profile.name
        avatar.setImageWith(url: profile.imageURL)
    }
    
    
    
}

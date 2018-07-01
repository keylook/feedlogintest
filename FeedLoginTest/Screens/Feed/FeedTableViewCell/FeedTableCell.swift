//
//  FeedTableCell.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 5/19/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import UIKit

class FeedTableCell: UITableViewCell {

    @IBOutlet weak var back: UIView!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleSource: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleImage.image = #imageLiteral(resourceName: "news-placeholder")
    }
    
    private func customLayout() {
        
        selectionStyle = .none
        
        back.backgroundColor = UIColor.white
        back.layer.cornerRadius = 10
        back.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        back.layer.shadowRadius = 3
        back.layer.shadowOpacity = 0.5
        back.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        articleImage.clipsToBounds = true
        articleImage.layer.cornerRadius = 10

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, hexColor(hex: "#002E60").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: back.bounds.minX, y: 0, width: UIScreen.main.bounds.width - 16, height: bounds.height)
        articleImage.layer.addSublayer(gradientLayer)
        
    }
    
    
    func updateWith(article: Article) {
        articleTitle.text = article.title
        articleSource.text = article.source.name
        
        if let imageUrl = article.imageUrl {
            articleImage.setImageWith(url: imageUrl)
        } else {
            articleImage.setImageWith(url: article.strHash)
        }
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        UIView.animate(withDuration: 0.33, animations: {
            self.back.transform = selected ? CGAffineTransform.init(scaleX: 0.95, y: 0.95): CGAffineTransform.identity
        })
    
    }
    
}

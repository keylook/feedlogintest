//
//  ImageLoader.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 5/20/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import UIKit

class ImageLoader {
    
    private static let imageCache = NSCache<NSString, AnyObject>()
    private static let client = NetworkClient()
    
    static func loadImage(url: String, result: @escaping(_ image: UIImage?) -> Void) {
        client.loadImage(url: url) { (imageData, error) in
            
            guard let imageData = imageData, let image = UIImage(data: imageData) else {
                result(#imageLiteral(resourceName: "news-placeholder"))
                return
            }
            setCachedImage(image: image, url: url)
            result(image)
        }
    }
    
    static private func setCachedImage(image: UIImage, url: String) {
        imageCache.setObject(image, forKey: url as NSString)
    }
    
    static func getCachedImage(url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString) as? UIImage
    }
    
    
    static func overwriteCachedImage(image: UIImage, url: String) {
        setCachedImage(image: image, url: url)
    }
    
    static func clearCache() {
        imageCache.removeAllObjects()
    }
    
    
    
    
}

extension UIImageView {
    
    /// Sets an image by given `url`
    /// If available in cache, returns cached version
    /// If cache is empty downloads it first
    func setImageWith(url: String) {
        if let cachedImage = ImageLoader.getCachedImage(url: url) {
            self.image = cachedImage
        } else {
            ImageLoader.loadImage(url: url) { image in
                DispatchQueue.main.async { self.image = image }
            }
        }
    }
    
    /// Sets an image with a specified `url`
    /// Use this method to overwrite existing image in cache
    /// - parameter url: a unique image url
    /// - parameter image: an image to be replaced in cache
    func setImageWith(url: String, image: UIImage) {
        self.image = image
        ImageLoader.overwriteCachedImage(image: image, url: url)
    }
    

    
    
}

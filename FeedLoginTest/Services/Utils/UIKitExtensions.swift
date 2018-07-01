//
//  UIKitExtensions.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 5/19/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import UIKit

public func hexColor(hex: String?) -> UIColor {
    if #available(iOS 10.0, *) {
        return colorFromP3(hex: hex)
    } else {
        return colorFrom(hex: hex)
    }
}


fileprivate func colorFrom(hex: String?) -> UIColor {
    
    if let hex = hex {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    } else {
        return UIColor.clear
    }
    
}


@available(iOS 10.0, *)
fileprivate func colorFromP3(hex: String?) -> UIColor {
    
    if let hex = hex {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        
        return UIColor(
            displayP3Red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    } else {
        return UIColor.clear
    }
    
}

//
//  Storage.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 6/30/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import Foundation

final class Storage {
    
    private enum StorageKeys: String {
        case vkID = "vkUserID"
        case vkToken = "vkToken"
    }
    
    private static let defaults = UserDefaults.standard
    
    static var vkUserID: String? {
        get { return defaults.string(forKey: StorageKeys.vkID.rawValue) }
        set { defaults.set(newValue, forKey: StorageKeys.vkID.rawValue) }
    }
    
    static var vkToken: String? {
        get { return defaults.string(forKey: StorageKeys.vkToken.rawValue) }
        set { defaults.set(newValue, forKey: StorageKeys.vkToken.rawValue) }
    }
    
    
    
    
}

//
//  ImageCacheManager.swift
//
//
//  Created by Sultan Irkaliyev on 09.06.2024.
//

import UIKit

public struct CacheConfiguration {
    var cacheCountLimit: Int
    var totalSpaceLimitInBytes: Int
    
    public init(cacheCountLimit: Int, totalSpaceLimitInBytes: Int) {
        self.cacheCountLimit = cacheCountLimit
        self.totalSpaceLimitInBytes = totalSpaceLimitInBytes
    }
}

final public class ImageCacheManager {
    
    public static let shared = ImageCacheManager()
    private init() {}
    
    private var cacheCountLimit = 100
    private var totalSpaceLimitInBytes = 1024 * 1024 * 20
    
    lazy var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = cacheCountLimit
        cache.totalCostLimit = totalSpaceLimitInBytes
        return cache
    }()
    
    public func setConfiguration(config: CacheConfiguration) {
        guard config.cacheCountLimit >= 0, config.totalSpaceLimitInBytes >= 0 else {
            Log.i("Couldn't set cache configuration. Invalid cache configuration values.")
            return
        }

        self.cacheCountLimit = config.cacheCountLimit
        imageCache.countLimit = self.cacheCountLimit
        
        self.totalSpaceLimitInBytes = config.totalSpaceLimitInBytes
        imageCache.totalCostLimit = self.totalSpaceLimitInBytes
    }
    
    func add(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
    }
    
    func remove(name: String) {
        imageCache.removeObject(forKey: name as NSString)
    }
    
    func get(name: String) -> UIImage? {
        guard let image = imageCache.object(forKey: name as NSString) else { return nil }
        return image
    }
    
    public func clearCache() {
        imageCache.removeAllObjects()
    }
}

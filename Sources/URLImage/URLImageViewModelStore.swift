//
//  URLImageViewModelStore.swift
//
//
//  Created by Sultan Irkaliyev on 10.06.2024.
//

import Foundation

public final class ImageViewModelStore {
    
    public static let shared = ImageViewModelStore()
    private var viewModels: [URL: URLImageViewModel] = [:]
    private var accessOrder: [URL] = []
    private var cacheLimit: Int
    
    private init(cacheLimit: Int = 100) {
        self.cacheLimit = cacheLimit
    }
    
    public func setCacheLimit(limit: Int) {
        if cacheLimit > 50 {
            self.cacheLimit = limit
        } else {
            Log.w("Couldn't set view model store cache limit. It should be greater than 50.")
        }
    }
    
    func viewModel(for url: URL) -> URLImageViewModel {
        if let existingViewModel = viewModels[url] {
            if let index = accessOrder.firstIndex(of: url) {
                accessOrder.remove(at: index)
            }
            accessOrder.append(url)
            return existingViewModel
        } else {
            let newViewModel = URLImageViewModel()
            viewModels[url] = newViewModel
            accessOrder.append(url)
            maintainCacheLimit()
            return newViewModel
        }
    }
    
    private func maintainCacheLimit() {
        while viewModels.count > cacheLimit {
            if let urlToRemove = accessOrder.first {
                viewModels.removeValue(forKey: urlToRemove)
                accessOrder.remove(at: 0)
            }
        }
    }
    
    public func clearStore() {
        viewModels.removeAll()
        accessOrder.removeAll()
    }
}

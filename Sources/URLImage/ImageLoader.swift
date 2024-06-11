//
//  ImageLoader.swift
//
//
//  Created by Sultan Irkaliyev on 09.06.2024.
//

import Foundation
import SwiftUI

final public class ImageLoader: ObservableObject {
    
    public static let shared = ImageLoader()
    private init() {}
    
    // MARK: - Properties -
    private let cache = ImageCacheManager.shared
    private var operations = [URL: ImageLoadOperation]()
    
    func loadImage(from url: URL, progressHandler: ((Double) -> Void)? = nil, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = cache.get(name: url.absoluteString) {
            completion(.success(cachedImage))
            return
        }
        
        if let operation = operations[url] {
            operation.completionBlock = {
                self.operations[url] = nil
            }
            return
        }
        
        let operation = ImageLoadOperation(url: url) { result in
            switch result {
            case .success(let loadedImage):
                self.cache.add(image: loadedImage, name: url.absoluteString)
                completion(.success(loadedImage))
            case .failure(let error):
                Log.e(error)
                completion(.failure(error))
            }
            self.operations[url] = nil
        } progressHandler: { progress in
            progressHandler?(progress)
        }
        
        operations[url] = operation
        ThreadPool.shared.addOperation(operation)
    }
    
    func cancelLoad(for url: URL) {
        operations[url]?.cancel()
        operations[url] = nil
    }
    
    func pauseLoad(for url: URL) {
        operations[url]?.pause()
    }
    
    public func cancelAllLoads() {
        operations.removeAll()
        ThreadPool.shared.getQueue().cancelAllOperations()
    }
}

extension ImageLoader {
    func testFuncGetOperations() -> [URL: ImageLoadOperation] {
        return operations
    }
}

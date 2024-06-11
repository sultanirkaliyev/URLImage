//
//  ThreadPool.swift
//
//
//  Created by Sultan Irkaliyev on 09.06.2024.
//

import Foundation

public struct ThreadConfiguration {
    var maxConcurrentOperationCount: Int
    
    public init(maxConcurrentOperationCount: Int) {
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
}

final public class ThreadPool {
    public static let shared = ThreadPool()
    private let queue: OperationQueue
    
    private init() {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 4
    }
    
    func addOperation(_ operation: Operation) {
        queue.addOperation(operation)
    }
    
    func getQueue() -> OperationQueue {
        return queue
    }
    
    public func setConfiguration(config: ThreadConfiguration) {
        self.queue.maxConcurrentOperationCount = config.maxConcurrentOperationCount
    }
}

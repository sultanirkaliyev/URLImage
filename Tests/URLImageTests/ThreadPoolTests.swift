//
//  ThreadPoolTests.swift
//
//
//  Created by Sultan Irkaliyev on 09.06.2024.
//

import XCTest
@testable import URLImage

final class ThreadPoolTests: XCTestCase {
    
    func testAddingOperationToQueue() {
        let threadPool = ThreadPool.shared
        
        let testOperation = BlockOperation {
            Log.i("Test operation executed")
        }
        
        threadPool.addOperation(testOperation)
        let queue = threadPool.getQueue()
        
        XCTAssertEqual(queue.operationCount, 1)
    }
}

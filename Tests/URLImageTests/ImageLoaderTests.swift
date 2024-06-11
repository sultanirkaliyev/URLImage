//
//  ImageLoaderTests.swift
//
//
//  Created by Sultan Irkaliyev on 09.06.2024.
//

import XCTest
@testable import URLImage

final class ImageLoaderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        ImageLoader.shared.cancelAllLoads()
        ImageCacheManager.shared.clearCache()
    }
    
    override class func tearDown() {
        ImageLoader.shared.cancelAllLoads()
        ImageCacheManager.shared.clearCache()
        super.tearDown()
    }
    
    func testImageLoader() {
        guard let testURL = URL(string: URLConstants.lightImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let loader = ImageLoader.shared
        XCTAssertEqual(loader.testFuncGetOperations().count, 0)
        
        loader.loadImage(from: testURL) { _ in }
        XCTAssertEqual(loader.testFuncGetOperations().count, 1)
    }
    
    func testLoadImageFromNetwork() {
        guard let testURL = URL(string: URLConstants.lightImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let loader = ImageLoader.shared
        let cache = ImageCacheManager.shared
        cache.remove(name: testURL.absoluteString)
        
        let expectation = self.expectation(description: "Image loaded from network")
        loader.loadImage(from: testURL) { result in
            switch result {
            case .success(let image):
                XCTAssertNotNil(image)
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testCancelLoadImage() {
        guard let testURL = URL(string: URLConstants.heavyImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let loader = ImageLoader.shared
        loader.cancelAllLoads()
        XCTAssertEqual(loader.testFuncGetOperations().count, 0)
        
        loader.loadImage(from: testURL) { _ in }
        XCTAssertEqual(loader.testFuncGetOperations().count, 1)
        
        let asyncExpectation = expectation(description: "Async operation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            loader.cancelLoad(for: testURL)
            asyncExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { _ in
            XCTAssertEqual(loader.testFuncGetOperations().count, 0)
        }
    }
    
    func testPauselLoadImage() {
        guard let testURL = URL(string: URLConstants.heavyImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let loader = ImageLoader.shared
        loader.cancelAllLoads()
        XCTAssertEqual(loader.testFuncGetOperations().count, 0)
        
        loader.loadImage(from: testURL) { _ in }
        let operations = loader.testFuncGetOperations()
        XCTAssertEqual(operations.count, 1)
        
        let asyncExpectation = expectation(description: "Async operation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            loader.pauseLoad(for: testURL)
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { _ in
            guard let dataTask = operations.first?.value.testFuncGetURLSessionDataTask() else {
                XCTFail("Data task not found.")
                return
            }
            XCTAssertEqual(dataTask.state, .suspended)
        }
    }
    
    func testResumelLoadImage() {
        guard let testURL = URL(string: URLConstants.heavyImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let loader = ImageLoader.shared
        loader.cancelAllLoads()
        XCTAssertEqual(loader.testFuncGetOperations().count, 0)
        
        loader.loadImage(from: testURL) { _ in }
        let operations = loader.testFuncGetOperations()
        XCTAssertEqual(operations.count, 1)
        
        let asyncExpectation = expectation(description: "Async operation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            loader.pauseLoad(for: testURL) // First pause calling for suspended state
            loader.pauseLoad(for: testURL) // Second pause calling for running state, after resume
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { _ in
            guard let dataTask = operations.first?.value.testFuncGetURLSessionDataTask() else {
                XCTFail("Data task not found.")
                return
            }
            XCTAssertEqual(dataTask.state, .running)
        }
    }
    
    func testCancelAllLoads() {
        guard let testURL = URL(string: URLConstants.heavyImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let loader = ImageLoader.shared
        loader.loadImage(from: testURL) { _ in }
        XCTAssertEqual(loader.testFuncGetOperations().count, 1)
        
        loader.cancelAllLoads()
        XCTAssertEqual(loader.testFuncGetOperations().count, 0)
    }
}

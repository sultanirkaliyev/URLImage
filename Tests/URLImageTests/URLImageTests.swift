//
//  URLImageTests.swift
//
//
//  Created by Sultan Irkaliyev on 09.06.2024.
//

import XCTest
@testable import URLImage

final class URLImageTests: XCTestCase {
    
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
    
    func testStartDownload() {
        guard let testURL = URL(string: URLConstants.lightImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let viewModel = URLImageViewModel()
        viewModel.startDownload(url: testURL)
        
        XCTAssertTrue(viewModel.isLoading)
    }
    
    func testSuccessfulImageLoad() {
        guard let testURL = URL(string: URLConstants.lightImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let viewModel = URLImageViewModel()
        viewModel.startDownload(url: testURL)
        XCTAssertTrue(viewModel.isLoading)
        
        let asyncExpectation = expectation(description: "Async operation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { _ in
            XCTAssertNotNil(viewModel.image)
        }
    }
    
    func testFailedImageLoad() {
        guard let testURL = URL(string: URLConstants.invalidImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let viewModel = URLImageViewModel()
        viewModel.startDownload(url: testURL)
        XCTAssertEqual(ImageLoader.shared.testFuncGetOperations().count, 1)
        XCTAssertTrue(viewModel.isLoading)
        
        let asyncExpectation = expectation(description: "Async operation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { _ in
            XCTAssertTrue(viewModel.isFailed)
            XCTAssertNil(viewModel.image)
            XCTAssertEqual(ImageLoader.shared.testFuncGetOperations().count, 0)
        }
    }
    
    func testPauseDownload() {
        guard let testURL = URL(string: URLConstants.heavyImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let viewModel = URLImageViewModel()
        viewModel.startDownload(url: testURL)
        XCTAssertEqual(ImageLoader.shared.testFuncGetOperations().count, 1)
        XCTAssertTrue(viewModel.isLoading)
        
        let asyncExpectation = expectation(description: "Async operation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            viewModel.pauseDownload(url: testURL)
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { _ in
            XCTAssertTrue(viewModel.isPaused)
            XCTAssertFalse(viewModel.isFailed)
            XCTAssertNil(viewModel.image)
            XCTAssertEqual(ImageLoader.shared.testFuncGetOperations().count, 1)
        }
    }
    
    func testResumeDownload() {
        guard let testURL = URL(string: URLConstants.heavyImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let viewModel = URLImageViewModel()
        viewModel.startDownload(url: testURL)
        XCTAssertEqual(ImageLoader.shared.testFuncGetOperations().count, 1)
        XCTAssertTrue(viewModel.isLoading)
        
        let asyncExpectation = expectation(description: "Async operation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            viewModel.pauseDownload(url: testURL)
            viewModel.resumeDownload(url: testURL)
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { _ in
            XCTAssertFalse(viewModel.isPaused)
            XCTAssertFalse(viewModel.isFailed)
            XCTAssertNil(viewModel.image)
            XCTAssertEqual(ImageLoader.shared.testFuncGetOperations().count, 1)
        }
    }
    
    func testStopDownload() {
        guard let testURL = URL(string: URLConstants.heavyImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let viewModel = URLImageViewModel()
        viewModel.startDownload(url: testURL)
        XCTAssertEqual(ImageLoader.shared.testFuncGetOperations().count, 1)
        XCTAssertTrue(viewModel.isLoading)
        
        let asyncExpectation = expectation(description: "Async operation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            viewModel.stopDownload(url: testURL)
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { _ in
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertFalse(viewModel.isPaused)
            XCTAssertFalse(viewModel.isFailed)
            XCTAssertNil(viewModel.image)
            XCTAssertEqual(ImageLoader.shared.testFuncGetOperations().count, 0)
        }
    }
}

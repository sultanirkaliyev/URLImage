//
//  ImageLoaderErrorTests.swift
//
//
//  Created by Sultan Irkaliyev on 09.06.2024.
//

import XCTest
@testable import URLImage

final class ImageLoaderErrorTests: XCTestCase {
    
    func testErrorDescription() {
        XCTAssertEqual(ImageLoaderError.networkUnavailable.description, "Network is unavailable. Please check your internet connection.")
        XCTAssertEqual(ImageLoaderError.networkConnectionLost.description, "Network is unavailable. Network connection lost.")
        XCTAssertEqual(ImageLoaderError.serverUnavailable.description, "Server is unavailable. Please try again later.")
        XCTAssertEqual(ImageLoaderError.timeout.description, "The request timed out. Please try again.")
        XCTAssertEqual(ImageLoaderError.invalidURL.description, "The URL provided is invalid.")
        XCTAssertEqual(ImageLoaderError.httpError(statusCode: 404).description, "HTTP error occurred with status code 404.")
        XCTAssertEqual(ImageLoaderError.invalidData.description, "Received invalid data.")
        XCTAssertEqual(ImageLoaderError.taskCancelled.description, "The image loading task was cancelled.")
        XCTAssertEqual(ImageLoaderError.securityError.description, "A security error occurred. Please check your network settings.")
        XCTAssertEqual(ImageLoaderError.unknownError.description, "An unknown error occurred. Please try again.")
    }
}

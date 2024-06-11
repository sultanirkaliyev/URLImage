//
//  ImageLoadOperationTests.swift
//
//
//  Created by Sultan Irkaliyev on 09.06.2024.
//

import XCTest
@testable import URLImage

final class ImageLoadOperationTests: XCTestCase {
    
    func testDataTaskCreation() {
        guard let testURL = URL(string: URLConstants.lightImage) else {
            XCTFail("Couldn't create image url.")
            return
        }
        
        let completionHandler: (Result<UIImage, ImageLoaderError>) -> Void = { _ in }
        let progressHandler: (Double) -> Void = { _ in }
        
        let imageLoadOperation = ImageLoadOperation(url: testURL, completionHandler: completionHandler, progressHandler: progressHandler)
        imageLoadOperation.main()
        
        XCTAssertNotNil(imageLoadOperation.testFuncGetURLSessionDataTask)
    }
}

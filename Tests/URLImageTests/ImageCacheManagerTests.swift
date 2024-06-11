//
//  ImageCacheManagerTests.swift
//
//
//  Created by Sultan Irkaliyev on 09.06.2024.
//

import XCTest
@testable import URLImage

final class ImageCacheManagerTests: XCTestCase {
    
    var imageCacheManager: ImageCacheManager?
    
    override func setUp() {
        super.setUp()
        imageCacheManager = ImageCacheManager.shared
        imageCacheManager?.clearCache()
    }
    
    override func tearDown() {
        imageCacheManager?.clearCache()
        imageCacheManager = nil
        super.tearDown()
    }
    
    func testAddImageToCache() {
        let image = UIImage(systemName: "play.circle.fill")
        let imageName = "testImageName"
        
        if let image = image {
            imageCacheManager?.add(image: image, name: imageName)
        } else {
            XCTFail("Test image not found")
        }
        
        XCTAssertNotNil(imageCacheManager?.get(name: imageName))
        XCTAssertEqual(imageCacheManager?.get(name: imageName), image)
    }
    
    func testRemoveImageFromCache() {
        let image = UIImage(systemName: "play.circle.fill")
        let imageName = "testImageName"
        
        if let image = image {
            imageCacheManager?.add(image: image, name: imageName)
        } else {
            XCTFail("Test image not found")
        }
        
        imageCacheManager?.remove(name: imageName)
        XCTAssertNil(imageCacheManager?.get(name: imageName))
    }
    
    func testClearCache() {
        let image1 = UIImage(systemName: "play.circle.fill")
        let image2 = UIImage(systemName: "stop.circle.fill")
        let imageName1 = "testImageName1"
        let imageName2 = "testImageName2"
        
        if let image1 = image1, let image2 = image2 {
            imageCacheManager?.add(image: image1, name: imageName1)
            imageCacheManager?.add(image: image2, name: imageName2)
        } else {
            XCTFail("Test images not found")
        }
        
        imageCacheManager?.clearCache()
        
        XCTAssertNil(imageCacheManager?.get(name: imageName1))
        XCTAssertNil(imageCacheManager?.get(name: imageName2))
    }
}

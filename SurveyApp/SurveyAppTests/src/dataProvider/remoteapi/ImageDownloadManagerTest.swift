//
//  ImageDownloadManagerTest.swift
//  SurveyAppTests
//
//  Created by Asif on 22/3/22.
//

import XCTest
@testable import SurveyApp

class ImageDownloadManagerTest: XCTestCase {
    
    func testImageDownloaderWithValidUrl(){
        let validImageUrl = "https://dhdbhh0jsld0o.cloudfront.net/m/287db81c5e4242412cc0_"
        var downloadedImageData : Data?
        let expectation = self.expectation(description: "ImageDownloadExpectation")
        ImageDownloadManager.shared.downloadImage(with: validImageUrl){(imageData, cached, urlString) in
            downloadedImageData = imageData
            expectation.fulfill()
        }
        waitForExpectations(timeout: 35, handler: nil)
        XCTAssertNotNil(downloadedImageData)
    }
    
    func testImageDownloaderWithInvalidUrl(){
        var downloadedImageData : Data?
        let expectation = self.expectation(description: "InvalidImageDownloadExpectation")
        ImageDownloadManager.shared.downloadImage(with: nil){(imageData, cached, urlString) in
            downloadedImageData = imageData
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertNil(downloadedImageData)
    }
    
}

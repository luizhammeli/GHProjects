//
//  GHAvatarImageViewTests.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 29/07/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest
@testable import GHProjects

final class GHAvatarImageViewTests: XCTestCase {
    func test_init_shouldNotRequestData() {
        let (_, service) = makeSUT()
        
        XCTAssertTrue(service.messages.isEmpty)
    }
    
    func test_intrinsicContentSize_shouldReturnCorrectValue() {
        let fakeSize = CGSize(width: 40, height: 40)
        let (sut, _) = makeSUT(size: fakeSize)
                
        XCTAssertEqual(sut.intrinsicContentSize, fakeSize)
    }
    
    func test_setupLayout_shouldSetDefaultImage() {
        let (sut, _) = makeSUT()
                
        XCTAssertEqual(sut.image, makeDefaultImage())
    }
    
    func test_setupLayout_shouldSetDefaultProperties() {
        let fakeSize = CGSize(width: 40, height: 40)
        let (sut, _) = makeSUT(size: fakeSize)
        
        XCTAssertEqual(sut.layer.cornerRadius, fakeSize.width / 2)
        XCTAssertEqual(sut.contentMode, .scaleToFill)
        XCTAssertTrue(sut.clipsToBounds)
    }
    
    func test_fetchImage_shouldSendCorrectURL() {
        let fakeURL = makeFakeStringURL()
        let (sut, service) = makeSUT()
        
        sut.fetchImage(stringUrl: fakeURL)
        
        XCTAssertEqual(service.urls, [fakeURL])
    }
    
    func test_fetchImage_shouldMaintainDefaultImageIfServiceCompletesWithError() {
        let (sut, service) = makeSUT()
        
        sut.fetchImage(stringUrl: makeFakeStringURL())
        service.complete(with: .failure(.invalidURL))
        
        XCTAssertEqual(sut.image, makeDefaultImage())
    }
    
    func test_fetchImage_shouldSetReceivedImageIfServiceSucceed() {
        let fakeImage = UIImage.make(withColor: .red)
        let (sut, service) = makeSUT()
        
        sut.fetchImage(stringUrl: makeFakeStringURL())
        service.complete(with: .success(fakeImage))
        
        XCTAssertEqual(sut.image, fakeImage)
    }
}

private extension GHAvatarImageViewTests {
    func makeSUT(size: CGSize = .zero) -> (GHAvatarImageView, ImageDownloaderSpy){
        let serviceSpy = ImageDownloaderSpy()
        let sut = GHAvatarImageView(size: size, imageDownloader: serviceSpy)
        
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: serviceSpy)

        return (sut, serviceSpy)
    }
    
    func makeDefaultImage(value: String = "testURL") -> UIImage {
        UIImage(named: "avatar-placeholder-dark")!
    }
    
    func makeFakeStringURL(value: String = "testURL") -> String {
        "https://\(value).com"
    }
}

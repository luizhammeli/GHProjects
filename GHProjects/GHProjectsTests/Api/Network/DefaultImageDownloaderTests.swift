//
//  DefaultImageDownloaderTests.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 29/07/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest
@testable import GHProjects

final class DefaultImageDownloaderTests: XCTestCase {
    override class func setUp() {
        URLProtocolStub.startIntercepting()
    }
    
    override class func tearDown() {
        URLProtocolStub.stopIntercepting()
    }
    
    func test_download_shouldReturnCorrectCachedImage() {
        var receivedResult: Result<UIImage, GHImageError>?
        let fakeImage = UIImage.make(withColor: .red)
        let cacheSpy = NSCacheSpy(fakeImage: fakeImage)
        let sut = makeSut(cacheSpy: cacheSpy)
        
        sut.download(stringURL: "testURL") { receivedResult = $0 }
        
        XCTAssertEqual(cacheSpy.requestedKeys, ["testURL"])
        XCTAssertEqual(receivedResult, .success(fakeImage))
    }
    
    func test_download_shouldFailWithInvalidURL() {
        var receivedResult: Result<UIImage, GHImageError>?
        let sut = makeSut()
        
        sut.download(stringURL: "") { receivedResult = $0 }
                
        XCTAssertEqual(receivedResult, .failure(.invalidURL))
    }
    
    func test_download_shouldSendCorrectURL() {
        let url = makeURL()
        let sut = makeSut()
        var receivedURL: URL?
        
        let exp = expectation(description: #function)
        
        URLProtocolStub.observeRequest { urlRequest in
            receivedURL = urlRequest.url
            exp.fulfill()
        }
        
        sut.download(stringURL: url.description) { _ in }
        
        wait(for: [exp], timeout: 1)
    
        XCTAssertEqual(receivedURL?.description, url.description)
    }
    
    func test_download_shouldFailIfResponseHasError() {
        expect(result: .failure(.fetch)) {
            URLProtocolStub.stub(response: nil, error: makeError(), data: nil)
        }
    }
    
    func test_download_shouldFailIfResponseIsEmpty() {
        expect(result: .failure(.fetch)) {
            URLProtocolStub.stub(response: nil, error: nil, data: nil)
        }
    }
    
    func test_download_shouldFailIfResponseHasInvalidData() {
        expect(result: .failure(.fetch)) {
            URLProtocolStub.stub(response: nil, error: nil, data: Data())
        }
    }
    
    func test_download_shouldSucceedfResponseHasValidImageData() {
        let imageData = makeImageData()
        
        expect(result: .success(imageData.image)) {
            URLProtocolStub.stub(response: nil, error: nil, data: imageData.data)
        }
    }
    
    func test_download_shouldSaveCacheIfRequestSucceed() {
        let url = makeURL()
        let cacheSpy = NSCacheSpy()
        let sut = makeSut(cacheSpy: cacheSpy)
        
        let exp = expectation(description: #function)
        URLProtocolStub.stub(response: nil, error: nil, data: makeImageData().data)
        sut.download(stringURL: url.description, completion: { _ in exp.fulfill() })
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(cacheSpy.sendedImages, [url.description])
    }
}

private extension DefaultImageDownloaderTests {
    func makeSut(cacheSpy: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()) -> (DefaultImageDownloader) {
        let sut = DefaultImageDownloader(cache: cacheSpy)
        return sut
    }
    
    func expect(result: Result<UIImage, GHImageError>,
                when action: @escaping () -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) {
        // Given
        let url = makeURL()
        var receivedResult: Result<UIImage, GHImageError>?
        let sut = makeSut()
        
        // When
        let exp = expectation(description: #function)
        action()
        sut.download(stringURL: url.description, completion: { result in
            receivedResult = result
            exp.fulfill()
        })
        
        // Then
        wait(for: [exp], timeout: 1)
        switch (receivedResult, result) {
        case (.success, .success):
            break
        case (.failure(let receivedError), .failure(let expectedError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail("Expect \(result) got \(String(describing: receivedResult)) instead", file: file, line: line)
        }
    }
}

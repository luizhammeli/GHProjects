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
    func test_download_() {
        let url = makeURL()
        var receivedResult: Result<UIImage, GHImageError>?
        let sut = makeSut()
        
        let exp = expectation(description: #function)
        URLProtocolStub.stub(url: url, response: nil, error: makeError(), data: nil)
        sut.download(stringURL: url.description, completion: { result in
            receivedResult = result
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(receivedResult, .failure(.fetch))
    }
    
    func test_download__() {
        let url = makeURL()
        var receivedResult: Result<UIImage, GHImageError>?
        let sut = makeSut()
        
        let exp = expectation(description: #function)
        URLProtocolStub.stub(url: url, response: nil, error: nil, data: nil)
        sut.download(stringURL: url.description, completion: { result in
            receivedResult = result
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(receivedResult, .failure(.fetch))
    }
    
    func test_download___() {
        let url = makeURL()
        var receivedResult: Result<UIImage, GHImageError>?
        let sut = makeSut()
        
        let exp = expectation(description: #function)
        URLProtocolStub.stub(url: url, response: nil, error: nil, data: Data())
        sut.download(stringURL: url.description, completion: { result in
            receivedResult = result
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(receivedResult, .failure(.fetch))
    }
    
    func test_download____() {
        let url = makeURL()
        var receivedResult: Result<UIImage, GHImageError>?
        let sut = makeSut()
        
        let exp = expectation(description: #function)
        URLProtocolStub.stub(url: url, response: nil, error: nil, data: makeImageData().data)
        sut.download(stringURL: url.description, completion: { result in
            receivedResult = result
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1)
        guard case .success = receivedResult else {
            XCTFail("Expect success got \(String(describing: receivedResult)) instead")
            return
        }
    }
    
    func test_download_____() {
        let url = makeURL()
        let cacheSpy = NSCacheSpy()
        let sut = makeSut(cacheSpy: cacheSpy)
        
        let exp = expectation(description: #function)
        URLProtocolStub.stub(url: url, response: nil, error: nil, data: makeImageData().data)
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
    
    func makeURL() -> URL {
        URL(string: "https://www.test.com")!
    }
    
    func makeError() -> NSError {
        NSError(domain: "", code: 1)
    }
    
    func makeImageData() -> (data: Data, image: UIImage) {
        let image = UIImage.make(withColor: .red)
        return (image.pngData()!, image)
    }
}

final class NSCacheSpy: NSCache<NSString, UIImage> {
    private let fakeImage: UIImage?
    var requestedKeys: [NSString] = []
    var sendedImages: [String] = []
    
    init(fakeImage: UIImage? = nil) {
        self.fakeImage = fakeImage
    }
    
    override func object(forKey key: NSString) -> UIImage? {
        requestedKeys.append(key)
        return fakeImage
    }
    
    override func setObject(_ obj: UIImage, forKey key: NSString) {
        sendedImages.append(String(key))
    }
}

private struct Stub {
    let error: Error?
    let response: URLResponse?
    let data: Data?
}

private class URLProtocolStub: URLProtocol {
    private static var stub: Stub?
    private static var requestObserver: ((URLRequest) -> Void)?
    
    static func stub(url: URL, response: URLResponse?, error: Error?, data: Data?) {
        URLProtocolStub.stub = Stub(error: error, response: response, data: data)
    }
    
    static func startIntercepting() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    static func stopIntercepting() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }
    
    static func observeRequest(_ observer: @escaping (URLRequest) -> Void) {
        requestObserver = observer
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let requestObserver = URLProtocolStub.requestObserver {
            client?.urlProtocolDidFinishLoading(self)
            return requestObserver(request)
        }

        if let response = URLProtocolStub.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        if let data = URLProtocolStub.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        URLProtocolStub.requestObserver = nil
    }
}

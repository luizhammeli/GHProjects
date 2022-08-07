//
//  DefaultNetworkManagerTests.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 02/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest
@testable import GHProjects

final class DefaultNetworkManagerTests: XCTestCase {
    func test_fetch_shouldFailWithInvalidURL() {
        var receivedResult: Result<Data, GHError>?
        let (sut, _) = makeSUT()
        
        sut.fetch(urlString: "",
                  method: .get,
                  parameters: [:],
                  headers: [:]) { receivedResult = $0 }
        
        XCTAssertEqual(receivedResult, .failure(.invalidURL))
    }
    
    func test_fetch_shouldSetCorrectURL() {
        let (sut, spy) = makeSUT()
        
        sut.fetch(urlString: "test",
                  method: .get,
                  parameters: [:],
                  headers: [:]) { _ in }
                
        XCTAssertEqual(spy.urls, ["https://api.github.com/test"])
    }
    
    func test_fetch_shouldCompleteWithError() {
        let (sut, spy) = makeSUT()
        let expectedResult: Result<Data, GHError> = .success(Data())
        var receivedResult: Result<Data, GHError>?
        
        sut.fetch(urlString: "test",
                  method: .get,
                  parameters: [:],
                  headers: [:]) { receivedResult = $0 }
        
        spy.complete(with: expectedResult)
                
        XCTAssertEqual(receivedResult, expectedResult)
    }
    
    func test_fetch_shouldCompleteWithSuccess() {
        let (sut, spy) = makeSUT()
        let expectedResult: Result<Data, GHError> = .failure(.genericError)
        var receivedResult: Result<Data, GHError>?
        
        sut.fetch(urlString: "test",
                  method: .get,
                  parameters: [:],
                  headers: [:]) { receivedResult = $0 }
        
        spy.complete(with: expectedResult)
                
        XCTAssertEqual(receivedResult, expectedResult)
    }
    
    func test_deInit_shouldCallNetworkManagerCancel() {
        let spy = DataRequestSpy()
        var sut: DefaultNetworkManager? = DefaultNetworkManager(request: spy)
        var didCancel = false
        
        let exp = expectation(description: #function)
        sut?.fetch(urlString: "", method: .get, parameters: [:], headers: [:], completion: { _ in })
        spy.cancelCalled = {
            didCancel = true
            exp.fulfill()
        }
        sut = nil
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(didCancel)
    }
}
 
private extension DefaultNetworkManagerTests {
    func makeSUT() -> (DefaultNetworkManager, DataRequestSpy) {
        let spy = DataRequestSpy()
        let sut = DefaultNetworkManager(request: spy)

        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: spy)
        
        return (sut, spy)
    }
}

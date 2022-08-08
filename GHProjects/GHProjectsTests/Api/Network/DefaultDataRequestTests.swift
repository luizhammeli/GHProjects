//
//  DefaultDataRequestTests.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 05/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

@testable import GHProjects

final class DefaultDataRequestTests: XCTestCase {
    override func setUp() {
        super.setUp()
        URLProtocolStub.startIntercepting()
    }
    
    override func tearDown() {
        super.setUp()
        URLProtocolStub.stopIntercepting()
    }
    
    func test_cancel_shouldCancelTasks() {
        // Given
        let sut = makeSUT()
        
        // When
        let task = sut.responseData(url: makeURL(), completion: { _ in })
        sut.cancel()
        
        // Then
        XCTAssertTrue(task.isCanceled)
    }
    
    func test_responseData_shouldSendCorrectURL() {
        // Given
        let fakeURL = makeURL()
        let sut = makeSUT()
        var receveivedRequest: URLRequest?
        
        // When
        let exp = expectation(description: #function)
        sut.responseData(url: fakeURL, completion: { _ in })
        
        URLProtocolStub.observeRequest { request in
            receveivedRequest = request
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        // Then
        XCTAssertEqual(receveivedRequest?.url, fakeURL)
    }
    
    func test_responseData_shouldCompleteWithCorrectErrorIfRequestFails() {
        assert(with: .failure(.unableToComplete)) {
            URLProtocolStub.stub(response: nil, error: makeError(), data: nil)
        }
    }
    
    func test_responseData_shouldCompleteWithCorrectErrorIfRequestFailsWithNilResponse() {
        assert(with: .failure(.invalidResponse)) {
            URLProtocolStub.stub(response: nil, error: nil, data: nil)
        }
    }
    
    func test_responseData_shouldCompleteWithCorrectErrorIfRequestFailsWithInvalidResponse() {
        assert(with: .failure(.invalidResponse)) {
            URLProtocolStub.stub(response: URLResponse(), error: nil, data: nil)
        }
    }
    
    func test_responseData_shouldCompleteWithCorrectErrorIfRequestFailsWithNon200Code() {
        assert(with: .failure(.invalidResponse)) {
            URLProtocolStub.stub(response: makeHttpURLResponse(with: 400), error: nil, data: nil)
        }
    }
    
    func test_responseData_shouldCompleteWithCorrectErrorIfRequestFailsWithNilData() {
        assert(with: .failure(.invalidData)) {
            URLProtocolStub.stub(response: makeHttpURLResponse(with: 200), error: nil, data: nil)
        }
    }
    
    func test_responseData_shouldCompleteWithCorrectErrorIfRequestFailsWithEmptyData() {
        assert(with: .failure(.invalidData)) {
            URLProtocolStub.stub(response: makeHttpURLResponse(with: 200), error: nil, data: Data())
        }
    }
    
    func test_responseData_shouldSucceed() {
        let fakeData = makeFakeData()
        
        assert(with: .success(fakeData)) {
            URLProtocolStub.stub(response: makeHttpURLResponse(with: 200), error: nil, data: fakeData)
        }
    }
}

private extension DefaultDataRequestTests {
    func makeSUT() -> DefaultDataRequest {
        let sut = DefaultDataRequest()
        
        checkMemoryLeak(for: sut)
        
        return sut
    }
    
    func assert(with result: (Result<Data, GHError>),
                with configuration: () -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) {
        // Given
        let sut = makeSUT()
        var expectedResult: (Result<Data, GHError>)?
        configuration()
                
        // When
        let exp = expectation(description: #function)
        sut.responseData(url: makeURL(), completion: { result in
            expectedResult = result
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1)
        
        // Then
        XCTAssertEqual(expectedResult, result, file: file, line: line)
    }
}

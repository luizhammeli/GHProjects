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
        let url = makeURL()
        let sut = DefaultDataRequest()
        
        // When
        let task = sut.responseData(url: url, completion: { _ in })
        sut.cancel()
        
        // Then
        XCTAssertTrue(task.isCanceled)
    }
}

private extension DefaultDataRequestTests {
    func makeSUT() -> DefaultDataRequest {
        let sut = DefaultDataRequest()
        
        return sut
    }
}

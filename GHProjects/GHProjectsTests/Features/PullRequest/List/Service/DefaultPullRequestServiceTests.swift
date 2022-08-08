//
//  DefaultPullRequestServiceTests.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 07/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest
@testable import GHProjects

final class DefaultPullRequestServiceTests: XCTestCase {
    func test_fetchPullRequestData_shouldSendCorrectURL() {
        let (sut, spy) = makeSUT(page: 1)
        sut.fetchPullRequestData("test_owner", repository: "test_repo", completion: { _, _  in })
        
        XCTAssertEqual(spy.urls, ["repos/test_owner/test_repo/pulls?per_page=20&page=1"])
    }
    
    func test_fetchPullRequestData_shouldCompleteOfInstanceHasBeenDealocated() {
        let networkManagerSpy = NetworkManagerSpy()
        var sut: DefaultPullRequestService? = DefaultPullRequestService(page: 0, networkManager: networkManagerSpy)
        var receivedValue: (Result<[PullRequest], GHError>, Bool)?
                
        sut?.fetchPullRequestData("test_owner",
                                  repository: "test_repo",
                                  completion: { receivedValue = ($0, $1) })
        sut = nil
        networkManagerSpy.complete(with: .success(Data()))                
        
        XCTAssertNil(receivedValue)
    }
}

private extension DefaultPullRequestServiceTests {
    func makeSUT(page: Int = 0) -> (DefaultPullRequestService, NetworkManagerSpy) {
        let networkManagerSpy = NetworkManagerSpy()
        let sut = DefaultPullRequestService(page: page, networkManager: networkManagerSpy)
        
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: networkManagerSpy)
        
        return (sut, networkManagerSpy)
    }
}

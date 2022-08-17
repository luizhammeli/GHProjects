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
    
    func test_fetchPullRequestData_shouldNotCompleteIfInstanceHasBeenDealocated() {
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
    
    func test_fetchPullRequestData_shouldFailIfManagerCompletesWithError() {
        let (sut, networkManagerSpy) = makeSUT()
        var receivedValue: (Result<[PullRequest], GHError>, Bool)?
        let expectedError: Result<[PullRequest], GHError> = .failure(.genericError)
                
        sut.fetchPullRequestData("test_owner",
                                  repository: "test_repo",
                                  completion: { receivedValue = ($0, $1) })
        networkManagerSpy.complete(with: .failure(.genericError))
        
        XCTAssertEqual(receivedValue?.0, expectedError)
        XCTAssertEqual(receivedValue?.1, false)
    }
    
    func test_fetchPullRequestData_shouldFailIfManagerSucceedWithInvalidData() {
        let (sut, networkManagerSpy) = makeSUT()
        var receivedValue: (Result<[PullRequest], GHError>, Bool)?
        let expectedError: Result<[PullRequest], GHError> = .failure(.invalidData)
                
        sut.fetchPullRequestData("test_owner",
                                  repository: "test_repo",
                                  completion: { receivedValue = ($0, $1) })
        networkManagerSpy.complete(with: .success(makeFakeData()))
        
        XCTAssertEqual(receivedValue?.0, expectedError)
        XCTAssertEqual(receivedValue?.1, false)
    }
    
    func test_fetchPullRequestData_shouldSucceedIfManagerCompletesWithSuccess() {
        let (sut, networkManagerSpy) = makeSUT()
        var receivedValue: (Result<[PullRequest], GHError>, Bool)?
        let expectedResultData: ([PullRequest], Data) = makePullRequestResponse(numberOfItems: 21)
                
        sut.fetchPullRequestData("test_owner",
                                  repository: "test_repo",
                                  completion: { receivedValue = ($0, $1) })
        networkManagerSpy.complete(with: .success(expectedResultData.1))
        
        XCTAssertEqual(receivedValue?.0, .success(expectedResultData.0))
        XCTAssertEqual(receivedValue?.1, true)
    }
    
    func test_fetchPullRequestData_shouldReturnFaleIfResult_() {
        let (sut, networkManagerSpy) = makeSUT()
        var receivedValue: (Result<[PullRequest], GHError>, Bool)?
        let expectedResultData: ([PullRequest], Data) = makePullRequestResponse()
                
        sut.fetchPullRequestData("test_owner",
                                  repository: "test_repo",
                                  completion: { receivedValue = ($0, $1) })
        networkManagerSpy.complete(with: .success(expectedResultData.1))
                
        XCTAssertEqual(receivedValue?.1, false)
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
    
    func makePullRequestResponse(numberOfItems: Int = 1) -> ([PullRequest], Data) {
        var values = [PullRequest]()
        for i in 0...numberOfItems { values.append(makeFakePullRequest(id: i)) }
        
        return (values, try! JSONEncoder().encode(values))
    }

}

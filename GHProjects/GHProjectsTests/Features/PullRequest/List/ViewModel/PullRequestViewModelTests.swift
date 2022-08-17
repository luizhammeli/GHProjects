//
//  PullRequestViewModelTests.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 16/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

@testable import GHProjects

final class PullRequestViewModelTests: XCTestCase {
    func test_fetchPullRequests_shouldSendOneServiceCallPerExecution() {
        // Given
        let (sut, spy) = makeSUT()
        
        // When
        sut.fetchPullRequests { _, _ in }
        
        // Then
        XCTAssertEqual(spy.requestData.count, 1)
    }
    
    func test_fetchPullRequests_shouldSendCorrectOwnerName() {
        // Given
        let fakeRepoName = "Test Repo"
        let (sut, spy) = makeSUT(repoName: fakeRepoName)
        
        // When
        sut.fetchPullRequests { _, _ in }
        
        // Then
        XCTAssertEqual(spy.requestData.first?.repository, fakeRepoName)
    }
    
    func test_fetchPullRequests_shouldSendCorrectRepoName() {
        // Given
        let fakeOwnerName = "Test Repo"
        let (sut, spy) = makeSUT(ownerName: fakeOwnerName)
        
        // When
        sut.fetchPullRequests { _, _ in }
        
        // Then
        XCTAssertEqual(spy.requestData.first?.owner, fakeOwnerName)
    }
    
    func test_fetchPullRequests_shouldNotCompleteIfInstanceHasBeenDealocated() {
        // Given
        let spy = PullRequestServiceSpy()
        var sut: DefaultPullRequestViewModel? = DefaultPullRequestViewModel(ownerName: "", repoName: "", service: spy)
        var result: ((Bool, String?))?
        
        // When
        sut?.fetchPullRequests { result = ($0, $1) }
        sut = nil
        spy.complete(with: .success([]))
        
        // Then
        XCTAssertNil(result)
    }
    
    func test_fetchPullRequests_shouldFailIfServiceCompleteWithError() {
        let (sut, spy) = makeSUT()
        var result: ((Bool, String?))?
        
        // When
        sut.fetchPullRequests { result = ($0, $1) }
        spy.complete(with: .failure(.invalidData))
        
        // Then
        XCTAssertEqual(result?.0, false)
        XCTAssertEqual(result?.1, "The data received from the server was invalid. Please try again.")
    }
    
    func test_fetchPullRequests_shouldSucceedIfServiceCompleteWithSuccess() {
        let (sut, spy) = makeSUT()
        var result: ((Bool, String?))?
        
        // When
        sut.fetchPullRequests { result = ($0, $1) }
        spy.complete(with: .success([]))
        
        // Then
        XCTAssertEqual(result?.0, true)
        XCTAssertEqual(result?.1, nil)
    }
    
    func test_fetchPullRequests_shouldReturnCorrectDataIfServiceCompleteWithSuccess() {
        let (sut, spy) = makeSUT()        
        let expectedResult = makeFakePullRequestModels()
        
        // When
        sut.fetchPullRequests { _, _ in }
        spy.complete(with: .success([expectedResult.0]))
        let receveivedData = sut.getPullRequestViewModelItem(with: IndexPath(item: 0, section: 0))
        
        // Then
        XCTAssertEqual(receveivedData, expectedResult.1)
    }
}

private extension PullRequestViewModelTests {
    func makeSUT(ownerName: String = "", repoName: String = "") -> (DefaultPullRequestViewModel, PullRequestServiceSpy) {
        let spy = PullRequestServiceSpy()
        let sut = DefaultPullRequestViewModel(ownerName: ownerName, repoName: repoName, service: spy)
        
        return (sut, spy)
    }
}

final class PullRequestServiceSpy: PullRequestService {
    var completions: [(Result<[PullRequest], GHError>, Bool) -> Void] = []
    var requestData = [(owner: String, repository: String)]()

    func fetchPullRequestData(_ owner: String,
                              repository: String,
                              completion: @escaping (Result<[PullRequest], GHError>, Bool) -> Void) {
        completions.append(completion)
        requestData.append((owner, repository))
    }
    
    func complete(with result: Result<[PullRequest], GHError>, success: Bool = true, at index: Int = 0) {
        completions[index](result, success)
    }
}

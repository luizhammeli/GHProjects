//
//  DefautPullRequestDetailsViewModelTests.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 26/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

@testable import GHProjects

final class DefautPullRequestDetailsViewModelTests: XCTestCase {
    func test_fetchPullRequests_shouldSetCorrectRequestData() {
        let expectedData = PullRequestDetailsServiceSpyModel(owner: "Test Owner",
                                                             repository: "Test Repository",
                                                             id: 10)
        let (sut, spy) = makeSUT(login: expectedData.owner,
                                 repoName: expectedData.repository,
                                 pullRequestNumber: expectedData.id)
        
        sut.fetchPullRequests { _, _ in }
        
        XCTAssertEqual(spy.receivedData, [expectedData])
    }
    
    func test_fetchPullRequests_shouldFailIfServiceCompleteWithFailure() {
        let (sut, spy) = makeSUT()
        var receivedResult: (success: Bool, message: String?)?
        
        sut.fetchPullRequests { receivedResult = (success: $0, message: $1) }
        
        spy.complete(with: .failure(.genericError))
        
        XCTAssertEqual(receivedResult?.success, false)
        XCTAssertEqual(receivedResult?.message, "Error to processing your request. Please try again later.")
    }
    
    func test_fetchPullRequests_should() {
        let expectedResult = makeFakePullRequestDetail()
        let (sut, spy) = makeSUT()
        var receivedResult: (success: Bool, message: String?)?
        
        sut.fetchPullRequests { receivedResult = (success: $0, message: $1) }
        
        spy.complete(with: .success(expectedResult.model))
        
        XCTAssertEqual(receivedResult?.success, true)
        XCTAssertNil(receivedResult?.message)
        XCTAssertEqual(sut.getPullRequestDetailViewModelItem(), expectedResult.viewModel)
    }
}

private extension DefautPullRequestDetailsViewModelTests {
    func makeSUT(login: String = "",
                 repoName: String = "",
                 pullRequestNumber: Int = 0) -> (DefautPullRequestDetailsViewModel, PullRequestDetailsServiceSpy) {
        let serviceSpy = PullRequestDetailsServiceSpy()
        let sut = DefautPullRequestDetailsViewModel(login: login,
                                                    repoName: repoName,
                                                    pullRequestNumber: pullRequestNumber,
                                                    service: serviceSpy)
        return (sut, serviceSpy)
    }
}

struct PullRequestDetailsServiceSpyModel: Equatable {
    let owner: String
    let repository: String
    let id: Int
}


final class PullRequestDetailsServiceSpy: PullRequestDetailsService {
    var receivedData = [PullRequestDetailsServiceSpyModel]()
    var completions = [(Result<PullRequestDetail, GHError>) -> Void]()
    
    func fetchPullRequestDetailsData(_ owner: String,
                                     repository: String,
                                     id: Int,
                                     completion: @escaping (Result<PullRequestDetail, GHError>) -> Void) {
        receivedData.append(.init(owner: owner, repository: repository, id: id))
        completions.append(completion)
    }
    
    func complete(with result: Result<PullRequestDetail, GHError>, at index: Int = 0) {
        completions[index](result)
    }
}

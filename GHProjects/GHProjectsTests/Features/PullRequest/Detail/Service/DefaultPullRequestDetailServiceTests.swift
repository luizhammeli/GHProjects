//
//  DefaultPullRequestDetailServiceTests.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 25/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

@testable import GHProjects

final class DefaultPullRequestDetailServiceTests: XCTestCase {
    func test_fetchPullRequestDetailData_shouldSendCorrectURL() {
        let (sut, networkSpy) = makeSUT()
    
        sut.fetchPullRequestDetailsData("test", repository: "repo", id: 1) { _ in }
        
        XCTAssertEqual(networkSpy.urls, ["repos/test/repo/pulls/1"])
    }
    
    func test_fetchPullRequestDetailData_shouldSendCorrectMethod() {
        let (sut, networkSpy) = makeSUT()
    
        sut.fetchPullRequestDetailsData("", repository: "", id: 1) { _ in }
        
        XCTAssertEqual(networkSpy.method, .get)
    }
    
    func test_fetchPullRequestDetailData_() {
        let (sut, networkSpy) = makeSUT()
        
        expect(sut: sut, with: .failure(.genericError)) {
            networkSpy.complete(with: .failure(.genericError))
        }
    }
    
    func test_fetchPullRequestDetailData_shouldFailIfNetworkManagerCompletesWithSuccessWithInvalidData() {
        let (sut, networkSpy) = makeSUT()
        
        expect(sut: sut, with: .failure(.invalidData)) {
            networkSpy.complete(with: .success(Data()))
        }
    }
    
    func test_fetchPullRequestDetailData_shouldSucceed() {
        let pullRequestDetail = makeFakeData()
        let (sut, networkSpy) = makeSUT()
        
        expect(sut: sut, with: .success(pullRequestDetail.model)) {
            networkSpy.complete(with: .success(pullRequestDetail.data))
        }
    }
}

private extension DefaultPullRequestDetailServiceTests {
    func makeSUT() -> (DefaultPullRequestDetailsService, NetworkManagerSpy) {
        let networkManagerSpy = NetworkManagerSpy()
        let sut = DefaultPullRequestDetailsService(networkManager: networkManagerSpy)
        
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: networkManagerSpy)

        return (sut, networkManagerSpy)
    }
    
    func expect(sut: DefaultPullRequestDetailsService,
                with result: Result<PullRequestDetail, GHError>,
                when action: @escaping () -> Void) {
        var receivedData: Result<PullRequestDetail, GHError>?

        sut.fetchPullRequestDetailsData("test", repository: "repo", id: 1) { receivedData = $0 }
        action()

        XCTAssertEqual(receivedData, result)
    }
    
    func makeFakeData() -> (model: PullRequestDetail, data: Data) {
        let pullRequestDetail = makeFakePullRequestDetail()
        let data = try! JSONEncoder().encode(pullRequestDetail)
        
        return (pullRequestDetail, data)
    }
}

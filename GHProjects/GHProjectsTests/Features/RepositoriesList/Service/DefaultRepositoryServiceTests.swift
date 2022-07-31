//
//  DefaultRepositoryServiceTests.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 07/07/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest
@testable import GHProjects

final class DefaultRepositoryServiceTests: XCTestCase {

    func test_fetchRepositoriesData_shouldSendCorrectRequestData() {
        // Given
        let (sut, networkSpy) = makeSUT(page: 1)

        // When
        sut.fetchRepositoriesData { _, _ in  }
        
        // Then
        XCTAssertEqual(networkSpy.urls, ["search/repositories?q=topic:javascript&per_page=20&page=1"])
        XCTAssertEqual(networkSpy.headers, [[:]])
        XCTAssertEqual(networkSpy.method, .get)
    }
    
    func test_fetchRepositoriesData_shouldIncrementURLPageValue() {
        // Given
        let (sut, networkSpy) = makeSUT()
        
        // When
        sut.fetchRepositoriesData { _, _ in  }
        networkSpy.complete(with: .success(makeValidResponseData().data))
        
        sut.fetchRepositoriesData { _, _ in  }
        networkSpy.complete(with: .success(makeValidResponseData().data))
        
        // Then
        XCTAssertEqual(networkSpy.urls, ["search/repositories?q=topic:javascript&per_page=20&page=0",
                                         "search/repositories?q=topic:javascript&per_page=20&page=1"])
    }
    
    func test_fetchRepositoriesData_shouldFailIfHttpClientCompletesWithError() {
        // Given
        var receivedError: RepositoryService.Result?
        let (sut, networkSpy) = makeSUT()
        
        // When
        sut.fetchRepositoriesData { receivedError = $0; _ = $1 }
        networkSpy.complete(with: .failure(.genericError))
        
        // Then
        XCTAssertEqual(receivedError, .failure(.genericError))
    }
    
    func test_fetchRepositoriesData_shouldFailIfHttpClientCompletesWithSuccessWithInvalidData() {
        // Given
        var receivedError: RepositoryService.Result?
        let (sut, networkSpy) = makeSUT()
        
        // When
        sut.fetchRepositoriesData { receivedError = $0; _ = $1 }
        networkSpy.complete(with: .success(Data()))
        
        // Then
        XCTAssertEqual(receivedError, .failure(.invalidData))
    }
    
    func test_fetchRepositoriesData_shouldSucceedIfHttpClientCompletesWithSuccess() {
        // Given
        var receivedResult: RepositoryService.Result?
        let expectedData = makeValidResponseData()
        let (sut, networkSpy) = makeSUT()
        
        // When
        sut.fetchRepositoriesData { receivedResult = $0; _ = $1 }
        networkSpy.complete(with: .success(expectedData.data))
        
        // Then
        XCTAssertEqual(receivedResult, .success(expectedData.repo))
    }
    
    func test_fetchRepositoriesData_shouldReturnFalseForPageIfClientCompletesWithEmptyArray() {
        // Given
        var receivedResult: Bool?
        let (sut, networkSpy) = makeSUT()
        
        // When
        sut.fetchRepositoriesData { _ = $0; receivedResult = $1 }
        networkSpy.complete(with: .success(makeValidResponseData().data))
        
        // Then
        XCTAssertEqual(false, receivedResult)
    }
    
    func test_fetchRepositoriesData_shouldReturnTrueForPageIfClientCompletesWithArrayWith20Items() {
        // Given
        var receivedResult: Bool?
        let (sut, networkSpy) = makeSUT()
        let items = makeRepositoryArray(numberOfItems: 20)
        
        // When
        sut.fetchRepositoriesData { _ = $0; receivedResult = $1 }
        networkSpy.complete(with: .success(makeValidResponseData(items: items).data))
        
        // Then
        XCTAssertEqual(true, receivedResult)
    }
    
    func test_fetchRepositoriesData_shouldReturn() {
        // Given
        var receivedResult: Bool?
        let (sut, networkSpy) = makeSUT()
        let items = makeRepositoryArray(numberOfItems: 19)
        
        // When
        sut.fetchRepositoriesData { _ = $0; receivedResult = $1 }
        networkSpy.complete(with: .success(makeValidResponseData(items: items).data))
        
        // Then
        XCTAssertEqual(false, receivedResult)
    }
}

private extension DefaultRepositoryServiceTests {
    func makeSUT(page: Int = 0) -> (DefaultRepositoryService, NetworkManagerSpy) {
        let networkManagerSpy = NetworkManagerSpy()
        let sut = DefaultRepositoryService(page: page, networkManager: networkManagerSpy)
        
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: networkManagerSpy)
        
        return (sut, networkManagerSpy)
    }
    
    func makeValidResponseData(items: [Repository] = []) -> (data: Data, repo: SearchRepositories) {
        let repo = SearchRepositories(items: items)
        let data = (try? JSONEncoder().encode(repo)) ?? Data()
        return (data, repo)
    }
    
    func makeRepositoryArray(numberOfItems: Int) -> [Repository] {
        var items = [Repository]()
        
        for _ in 1...numberOfItems {
            items.append(makeRepositoryItems())
        }
        
        return items
    }
}

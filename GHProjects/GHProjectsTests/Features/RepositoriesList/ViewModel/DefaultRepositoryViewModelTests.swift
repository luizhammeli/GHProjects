//
//  DefaultRepositoryViewModelTests.swift
//  GHProjectsTests
//
//  Created by Jonathan Bijos on 27/03/20.
//  Copyright © 2020 PEBMED. All rights reserved.
//

@testable import GHProjects
import XCTest

final class DefaultRepositoryViewModelTests: XCTestCase {
    func test_fetchRepositories_shouldFailIfServiceCompletesWithError() {
        let (sut, service) = makeSUT()
        
        expect(sut: sut, with: (false, "Error to processing your request. Please try again later.")) {
            service.complete(with: .failure(.genericError), hasMoreData: false)
        }
    }
    
    func test_fetchRepositories_shouldSucceedIfServiceCompletesWithSuccessWithEmptyData() {
        let (sut, service) = makeSUT()
        
        expect(sut: sut, with: (true, nil)) {
            service.complete(with: .success(SearchRepositories(items: [])), hasMoreData: false)
        }
    }
    
    func test_fetchRepositories_shouldNotCompleteIfSutHasBeenDealocated() {
        // Given        
        let serviceSpy = RepositoryServiceSpy()
        var sut: DefaultRepositoryViewModel? = DefaultRepositoryViewModel(service: serviceSpy)
        var receivedResult: (Bool, String?)?
        
        // When
        sut?.fetchRepositories(completion: { receivedResult = ($0, $1) })
        sut = nil
        serviceSpy.complete(with: .success(SearchRepositories(items: [])), hasMoreData: false)
        
        // Then
        XCTAssertNil(receivedResult)
    }
    
    func test_getRepositoryViewModelNumberOfItems_shouldReturnCorrectNumber() {
        // Given
        let (sut, service) = makeSUT()
        let fakeSearchRepository = SearchRepositories(items: [makeRepository().model, makeRepository().model])

        // When
        sut.fetchRepositories(completion: { _,_  in })
        service.complete(with: .success(fakeSearchRepository), hasMoreData: false)
        
        // Then
        XCTAssertEqual(sut.getRepositoryViewModelNumberOfItems(), 2)
    }
    
    func test_getRepositoryViewModelNumberOfItems_shouldReturnCorrectValueForItem() {
        // Given
        let (sut, service) = makeSUT()
        let fakeRepositories = [makeRepository(), makeRepository(id: 1)]
        let fakeSearchRepository = SearchRepositories(items: [fakeRepositories[0].model, fakeRepositories[1].model])

        // When
        sut.fetchRepositories(completion: { _,_  in })
        service.complete(with: .success(fakeSearchRepository), hasMoreData: false)
        
        // Then
        XCTAssertEqual(sut.getRepositoryViewModelItem(with: IndexPath(item: 0, section: 0)), fakeRepositories[0].viewModel)
        XCTAssertEqual(sut.getRepositoryViewModelItem(with: IndexPath(item: 1, section: 0)), fakeRepositories[1].viewModel)
    }
    
    func test_hasMoreData_shouldInitializeAsTrue() {
        // Given, When
        let (sut, _) = makeSUT()
        
        // Then
        XCTAssertTrue(sut.hasMoreData)
    }
    
    func test_hasMoreData_shouldSetValueAsTrueIfServiceCompletesWithError() {
        // Given, When
        let (sut, service) = makeSUT()
        
        // Then
        expect_(sut: sut, with: true) {
            service.complete(with: .failure(.invalidData), hasMoreData: false)
        }
    }
    
    func test_hasMoreData_shouldSetValueAsTrueIfServiceCompletesWithTrue() {
        // Given, When
        let (sut, service) = makeSUT()
        
        // Then
        expect_(sut: sut, with: true) {
            service.complete(with: .success(.init(items: [])), hasMoreData: true)
        }
    }
    
    func test_hasMoreData_shouldSetValueAsFalseIfServiceCompletesWithFalse() {
        // Given, When
        let (sut, service) = makeSUT()
        
        // Then
        expect_(sut: sut, with: false) {
            service.complete(with: .success(.init(items: [])), hasMoreData: false)
        }
    }
}

private extension DefaultRepositoryViewModelTests {
    func makeSUT() -> (DefaultRepositoryViewModel, RepositoryServiceSpy) {
        let serviceSpy = RepositoryServiceSpy()
        let sut = DefaultRepositoryViewModel(service: serviceSpy)
        
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: serviceSpy)
        
        return (sut, serviceSpy)
    }
    
    func expect(sut: DefaultRepositoryViewModel,
                with result: (Bool, String?),
                when action: () -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) {
        // Given
        var receivedResult: (Bool, String?)?
        
        // When
        sut.fetchRepositories(completion: { receivedResult = ($0, $1) })
        action()
        
        // Then
        XCTAssertEqual(receivedResult?.0, result.0, file: file, line: line)
        XCTAssertEqual(receivedResult?.1, result.1, file: file, line: line)
    }
    
    func expect_(sut: DefaultRepositoryViewModel, with value: Bool, when action: () -> Void) {
        sut.fetchRepositories(completion: { _,_  in })
        action()
                
        XCTAssertEqual(sut.hasMoreData, value)
    }
}

final class RepositoryServiceSpy: RepositoryService {
    var completions: [(Result<SearchRepositories, GHError>, Bool) -> Void] = []
    
    func fetchRepositoriesData(completion: @escaping (Result<SearchRepositories, GHError>, Bool) -> Void) {
        completions.append(completion)
    }
    
    func complete(with result: Result<SearchRepositories, GHError>, hasMoreData: Bool, at index: Int = 0) {
        completions[index](result, hasMoreData)
    }
}

//
//  PullRequestListCoordinatorTests.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 08/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest
@testable import GHProjects

final class PullRequestListCoordinatorTests: XCTestCase {

    func test_start_shouldSetCorrectController() {
        let (sut, spy) = makeSUT()
        
        sut.start()
        
        XCTAssertEqual(spy.pushedControllers.count, 1)
        XCTAssertTrue(spy.pushedControllers.first is PullRequestListViewController)
    }
    
    func test_gotToDetail_shouldStartDetailFlow() {
        // Given
        let (sut, spy) = makeSUT()
        
        // When
        sut.start()
        sut.goToDetail(viewModelItem: makePullRequestViewModelItem(), ownerName: "", repoName: "")
        
        // Then
        XCTAssertEqual(spy.pushedControllers.count, 2)
        XCTAssertTrue(spy.pushedControllers.last is PullRequestDetailViewController)
    }
}

extension PullRequestListCoordinatorTests {
    func makeSUT() -> (PullRequestListCoordinator, NavigationControllerSpy) {
        let navigationControllerSpy = NavigationControllerSpy()
        let sut = PullRequestListCoordinator(navigationController: navigationControllerSpy,
                                             factory: DependencyContainer(),
                                             viewModelItem: makeRepository().viewModel)

         return (sut, navigationControllerSpy)
    }
}

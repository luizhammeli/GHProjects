//
//  RepositoriesListCoordinatorTests.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 26/07/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest
@testable import GHProjects

final class RepositoriesListCoordinatorTests: XCTestCase {
    func test_start_shouldSetCorrectControllerInTheNavigationFlow() {
        // Given
        let (sut, navController) = makeSUT()
        
        // When
        sut.start()
        
        // Then
        XCTAssertEqual(navController.viewControllers.count, 1)
        XCTAssertTrue(navController.viewControllers[0] is RepositoriesListViewController)
    }
    
    func test_goToPullRequestList_() {
        // Given
        let (sut, navController) = makeSUT()
        
        // When
        sut.goToPullRequestList(viewModelItem: makeRepository().viewModel)
        
        // Then
        XCTAssertEqual(navController.pushedControllers.count, 1)
        XCTAssertTrue(navController.pushedControllers[0] is PullRequestListViewController)
    }
}


// MARK: - Helpers

private extension RepositoriesListCoordinatorTests {
    func makeSUT() -> (sut: RepositoriesListCoordinator, navigationController: NavigationControllerSpy) {
        let navController = NavigationControllerSpy()
        let sut = RepositoriesListCoordinator(navigationController: navController,
                                              factory: DependencyContainer())

        return (sut, navController)
    }
}

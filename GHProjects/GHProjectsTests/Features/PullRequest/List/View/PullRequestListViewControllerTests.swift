//
//  PullRequestListViewControllerTests.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 17/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

@testable import GHProjects

final class PullRequestListViewControllerTests: XCTestCase {
    func test_init_() {
        let (_, spy) = makeSUT()
                
        XCTAssertTrue(spy.completions.isEmpty)
    }
    
    func test_getPullRequests_shouldPresentAlertCorrectlyIfViewModelCompletesWithError() {
        let (sut, spy) = makeSUT()
        UIApplication.shared.windows.first?.rootViewController = sut
        
        sut.loadViewIfNeeded()
        spy.complete(with: .failure(.genericError))
        
        guard let alertController = sut.presentedViewController as? UIAlertController else {
            XCTFail("Expected UIAlertController as presented view controller")
            return
        }
        
        XCTAssertEqual(alertController.message, "Error to processing your request. Please try again later.")
        XCTAssertEqual(alertController.title, "Bad Stuff Happend")
    }
    
    func test_getPullRequests_shouldReloadListDataIfViewModelCompletesWithSuccess() {
        let (sut, spy) = makeSUT()
        
        sut.loadViewIfNeeded()
        spy.complete(with: .success([makeFakePullRequest(), makeFakePullRequest()]))
        
        XCTAssertEqual(sut.collectionView(sut.collectionView, numberOfItemsInSection: 0), 2)
    }
}

private extension PullRequestListViewControllerTests {
    func makeSUT(coordinatorSpy: PullRequestListCoordinatorSpy = PullRequestListCoordinatorSpy(), viewModelItem: RepositoryViewModelItem = makeRepository().viewModel) -> (PullRequestListViewController, PullRequestServiceSpy) {
        let serviceSpy = PullRequestServiceSpy()
        let sut = DependencyContainer().makePullRequestListViewController(coordinator: coordinatorSpy,
                                                                                 viewModelItem: viewModelItem,
                                                                                 service: serviceSpy)

        return (sut, serviceSpy)
    }
}


final class PullRequestListCoordinatorSpy: PullRequestListCoordinatorProtocol {
    func goToDetail(viewModelItem: PullRequestViewModelItem, ownerName: String, repoName: String) {
        
    }
    
}

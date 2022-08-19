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
        let (_, spy) = makeSUT(shouldLoad: false)
                
        XCTAssertTrue(spy.completions.isEmpty)
    }
    
    func test_getPullRequests_shouldPresentAlertCorrectlyIfViewModelCompletesWithError() {
        let (sut, spy) = makeSUT()
        UIApplication.shared.windows.first?.rootViewController = sut
        
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
                
        spy.complete(with: .success([makeFakePullRequest(), makeFakePullRequest()]))
        
        XCTAssertEqual(sut.numberOfItems(), 2)
    }
    
    func test_cellForItem_shouldSetCorrectCellData() {
        let (sut, spy) = makeSUT()
        let fakePullRequest = makeFakePullRequestModels(body: "Body")
        
        spy.complete(with: .success([fakePullRequest.0]))
        let view = sut.viewForItem(at: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(view.titleLabel.text, fakePullRequest.1.title)
        XCTAssertEqual(view.desciprionLabel.text, fakePullRequest.1.body)
        XCTAssertEqual(view.dateLabel.text, fakePullRequest.1.createdAt)
        XCTAssertEqual(view.userLoginLabel.text, fakePullRequest.1.login)
        XCTAssertTrue(view.separatorView.isHidden)
    }
    
    func test_cellForItem_() {
        let (sut, spy) = makeSUT()
        let fakePullRequests = [makeFakePullRequestModels().0, makeFakePullRequestModels().0]
                
        spy.complete(with: .success(fakePullRequests))
        let view = sut.viewForItem(at: IndexPath(item: 0, section: 0))
        

        XCTAssertFalse(view.separatorView.isHidden)
    }
    
    func test_cellForItem__() {
        let (sut, spy) = makeSUT()
        let fakePullRequests = [makeFakePullRequestModels().0, makeFakePullRequestModels().0]
                
        spy.complete(with: .success(fakePullRequests), hasMoreData: false)
        sut.viewDidLoad()
        

        XCTAssertEqual(spy.completions.count, 1)
    }
    
    func test_willDisplay_shouldStartRequestForLastItemIfHasMoreData() {
        let (sut, spy) = makeSUT()
        let fakePullRequests = [makeFakePullRequestModels().0]
        
        spy.complete(with: .success(fakePullRequests), hasMoreData: true)
        sut.display()

        XCTAssertEqual(spy.completions.count, 2)
    }
    
    func test_willDisplay_shouldNotStartRequestForNonLastItem() {
        let (sut, spy) = makeSUT()
        let fakePullRequests = [makeFakePullRequestModels().0, makeFakePullRequestModels().0]
        
        spy.complete(with: .success(fakePullRequests), hasMoreData: true)
        sut.display()
        

        XCTAssertEqual(spy.completions.count, 1)
    }
    
    func test_willDisplay_shouldNotStartRequestIfViewModelHasNotMoreData() {
        let (sut, spy) = makeSUT()
        let fakePullRequests = [makeFakePullRequestModels().0]
                
        spy.complete(with: .success(fakePullRequests), hasMoreData: false)
        sut.display()
        

        XCTAssertEqual(spy.completions.count, 1)
    }
    
    func test_didSelected_() {
        let coordinator = PullRequestListCoordinatorSpy()
        let (sut, spy) = makeSUT(coordinatorSpy: coordinator)
        let fakePullRequests = makeFakePullRequestModels()
                
        spy.complete(with: .success([fakePullRequests.0]), hasMoreData: false)
        sut.collectionView(sut.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        

        XCTAssertEqual(coordinator.receivedData, [fakePullRequests.1])
    }
}

private extension PullRequestListViewControllerTests {
    func makeSUT(
        coordinatorSpy: PullRequestListCoordinatorSpy = PullRequestListCoordinatorSpy(),
        viewModelItem: RepositoryViewModelItem = makeRepository().viewModel,
        shouldLoad: Bool = true
    ) -> (PullRequestListViewController, PullRequestServiceSpy) {
        let serviceSpy = PullRequestServiceSpy()
        let sut = DependencyContainer().makePullRequestListViewController(coordinator: coordinatorSpy,
                                                                                 viewModelItem: viewModelItem,
                                                                                 service: serviceSpy)
        if shouldLoad {
            sut.loadViewIfNeeded()
        }

        return (sut, serviceSpy)
    }
}


final class PullRequestListCoordinatorSpy: PullRequestListCoordinatorProtocol {
    var receivedData: [PullRequestViewModelItem] = []

    func goToDetail(viewModelItem: PullRequestViewModelItem, ownerName: String, repoName: String) {
        receivedData.append(viewModelItem)
    }
}

fileprivate extension PullRequestListViewController {
    func numberOfItems(in section: Int = 0) -> Int {
        return collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func viewForItem(at index: IndexPath) -> PullRequestCollectionViewCell {
        return collectionView(collectionView, cellForItemAt: index) as! PullRequestCollectionViewCell
    }
    
    func display(for indexPath: IndexPath = IndexPath(item: 0, section: 0)) {
        collectionView(collectionView, willDisplay: UICollectionViewCell(), forItemAt: indexPath)
    }
}

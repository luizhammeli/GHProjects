//
//  RepositoriesListViewControllerTests.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 27/07/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest
@testable import GHProjects

final class RepositoriesListViewControllerTests: XCTestCase {
    func test_init_shouldNotRequestData() {
        let (_, service) = makeSUT()
        
        XCTAssertTrue(service.completions.isEmpty)
    }

    func test_viewDidLoad_shouldStartDataRequest() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
                
        XCTAssertEqual(service.completions.count, 1)
    }

    func test_getRepositories_shouldShowErrorAlertCorrectly() {
        let (sut, service) = makeSUT()
        UIApplication.shared.windows.first?.rootViewController = sut
        
        sut.loadViewIfNeeded()
        service.complete(with: .failure(.invalidData), hasMoreData: false)
        
        guard let alertController = sut.presentedViewController as? UIAlertController else {
            XCTFail("Expected UIAlertController as presented view controller")
            return
        }
        
        XCTAssertEqual(alertController.message, "The data received from the server was invalid. Please try again.")
        XCTAssertEqual(alertController.title, "Bad Stuff Happend")
    }

    func test_getRepositories_shouldNotStartRequestIfHasNoPaginationData() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.complete(with: .success(.init(items: [])), hasMoreData: false)
        
        sut.viewDidLoad()
        
        XCTAssertEqual(service.completions.count, 1)
    }

    func test_numberOfItems_shouldReturnCorrectValue() {
        let (sut, service) = makeSUT()
        let fakeRepository = makeRepository().model
        
        sut.loadViewIfNeeded()
        service.complete(with: .success(.init(items: [fakeRepository])), hasMoreData: false)
        
        XCTAssertEqual(sut.numberOfItems(), 1)
    }
    
    func test_cellForItem_shouldReturnCorrectCell() {
        let (sut, service) = makeSUT()
        let fakeRepository = makeRepository().model
        
        sut.loadViewIfNeeded()
        service.complete(with: .success(.init(items: [fakeRepository])), hasMoreData: false)
        let cell = sut.cellForItem(at: 0)
        
        XCTAssertEqual(cell?.titleLabel.text, "Test Repo 0")
        XCTAssertEqual(cell?.desciprionLabel.text, "Test Description")
        XCTAssertEqual(cell?.companyLabel.text, "• Test Owner")
        
        XCTAssertEqual(cell?.startsRepositoryView.numberLabel.text, "12")
        XCTAssertEqual(cell?.startsRepositoryView.imageView.image, UIImage(systemName: "star.fill"))
        
        XCTAssertEqual(cell?.forkRepositoryView.numberLabel.text, "13")
        XCTAssertEqual(cell?.forkRepositoryView.imageView.image, UIImage(systemName: "arrow.merge"))
        
        XCTAssertEqual(cell?.issuesRepositoryView.numberLabel.text, "14")
        XCTAssertEqual(cell?.issuesRepositoryView.imageView.image, UIImage(systemName: "exclamationmark.circle"))
        XCTAssertEqual(cell?.issuesRepositoryView.imageView.image, UIImage(systemName: "exclamationmark.circle"))        
    }
    
    func test_cellForItem_shouldReturnCorrectCellWithFallbackDescription() {
        let (sut, service) = makeSUT()
        let fakeRepository = makeRepository(description: nil).model
        
        sut.loadViewIfNeeded()
        service.complete(with: .success(.init(items: [fakeRepository])), hasMoreData: false)
        let cell = sut.cellForItem(at: 0)
        
        XCTAssertEqual(cell?.desciprionLabel.text, "No description available")
    }
    
    func test_cellForItem_shouldShowOrHideCellSeparatorViewCorrectly() {
        let (sut, service) = makeSUT()
        let fakeRepository = makeRepository().model
        let fakeRepository2 = makeRepository().model
        
        sut.loadViewIfNeeded()
        service.complete(with: .success(.init(items: [fakeRepository, fakeRepository2])), hasMoreData: false)
        
        let cell = sut.cellForItem(at: 0)
        let cell2 = sut.cellForItem(at: 1)
        XCTAssertEqual(cell?.separatorView.isHidden, false)
        XCTAssertEqual(cell2?.separatorView.isHidden, true)
    }
    
    func test_didSelectItem_shouldStartCoordinatorFlow() {
        let coordinator = RepositoriesListCoordinatorSpy()
        let (sut, service) = makeSUT(coordinator: coordinator)
        let fakeRepository = makeRepository()
        
        sut.loadViewIfNeeded()
        service.complete(with: .success(.init(items: [fakeRepository.model])), hasMoreData: false)
        sut.didSelectItem(at: 0)
        
        XCTAssertEqual(coordinator.sendedViewModels, [fakeRepository.viewModel])
    }
    
    func test_referenceSizeForFooter_shouldReturnCorrectValueIfViewModelHasMoreData() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.complete(with: .success(.init(items: [])), hasMoreData: true)
        
        XCTAssertEqual(sut.footerSize(), .init(width: 0, height: 40))
    }
    
    func test_referenceSizeForFooter_shouldReturnCorrectValueIfViewModelHasNoData() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.complete(with: .success(.init(items: [])), hasMoreData: false)
        
        XCTAssertEqual(sut.footerSize(), .zero)
    }
    
    func test_willDisplay_shouldStartDataRequest() {
        let (sut, service) = makeSUT()
        let fakeResult: Result<SearchRepositories, GHError> = .success(.init(items: [makeRepository().model]))
        
        sut.loadViewIfNeeded()
        service.complete(with: fakeResult, hasMoreData: true)
        sut.wilDisplay(at: 0)
        
        XCTAssertEqual(service.completions.count, 2)
    }
    
    func test_sizeForItem_shouldReturnCorrectValue() {
        let (sut, service) = makeSUT()
        let fakeModel = makeRepository()
        let fakeResult: Result<SearchRepositories, GHError> = .success(.init(items: [fakeModel.model]))
        
        sut.loadViewIfNeeded()
        service.complete(with: fakeResult, hasMoreData: true)
        
        XCTAssertEqual(sut.sizeForItem(at: 0), sut.registeredCellSize(with: fakeModel.viewModel.description))
    }
}

// MARK: - Helpers

private extension RepositoriesListViewControllerTests {
    func makeSUT(coordinator: RepositoriesListCoordinatorSpy = RepositoriesListCoordinatorSpy()) -> (RepositoriesListViewController, RepositoryServiceSpy) {
        let serviceSpy = RepositoryServiceSpy()
        let sut = DependencyContainer().makeRepositoriesListViewController(coordinator: coordinator,
                                                                           service: serviceSpy)

        return (sut, serviceSpy)
    }
}

// MARK: - Controller Helper Extensions

fileprivate extension RepositoriesListViewController {
    func numberOfItems(in section: Int = 0) -> Int {
        collectionView.numberOfItems(inSection: 0)
    }
    
    @discardableResult
    func cellForItem(at index: Int, in section: Int = 0) -> RepositoryCollectionViewCell? {
        collectionView(collectionView, cellForItemAt: IndexPath(item: index, section: section)) as? RepositoryCollectionViewCell
    }
    
    func didSelectItem(at index: Int, in section: Int = 0) {
        cellForItem(at: index, in: section)
        collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
    }
    
    func footerSize(in section: Int = 0) -> CGSize {
        collectionView(collectionView, layout: collectionView.collectionViewLayout, referenceSizeForFooterInSection: section)
    }
    
    func wilDisplay(at index: Int, in section: Int = 0) {
        collectionView(collectionView,
                       willDisplay: UICollectionViewCell(),
                       forItemAt: .init(item: index, section: section))
    }
    
    func sizeForItem(at index: Int, in section: Int = 0) -> CGSize {
        collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: .init(item: index, section: section))
    }
    
    func registeredCellSize(with description: String) -> CGSize {
        RepositoryCollectionViewCell.getCellHeight(with: description)
    }
}

//
//  PullRequestDetailCoordinatorTests.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 26/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

@testable import GHProjects

final class PullRequestDetailCoordinatorTests: XCTestCase {
    func test_start_shouldAddPullRequestDetailToNavigationStack() {
        let (sut, navigationController) = makeSUT()
        
        sut.start()
        
        XCTAssertEqual(navigationController.pushedControllers.count, 1)
        XCTAssertTrue(navigationController.pushedControllers.first is PullRequestDetailViewController)
    }
    
    func test_goToUserDetail_shouldAddUserDetailToNavigationStack() {
        let (sut, navigationController) = makeSUT()
        setWindow(rootController: navigationController)

        sut.goToUserDetail(userName: "Test")
                
        guard let presentedNavigationController = navigationController.presentedViewController as? UINavigationController else {
            XCTFail("Expected UINavigation controller as presented view controller instead got \(String(describing: navigationController.presentedViewController))")
            return
        }
        
        XCTAssertEqual(presentedNavigationController.viewControllers.count, 1)
        XCTAssertTrue(presentedNavigationController.viewControllers.first is UserDetailViewController)
    }
}

private extension PullRequestDetailCoordinatorTests {
    func makeSUT() -> (PullRequestDetailCoordinator, NavigationControllerSpy) {
        let navController = NavigationControllerSpy()
        let pullRequestViewModel = makePullRequestViewModelItem()
        
        let sut = PullRequestDetailCoordinator(navigationController: navController,
                                               factory: DependencyContainer(),
                                               viewModelItem: pullRequestViewModel,
                                               ownerName: "Test Owner",
                                               repoName: "Test Repo")
        return (sut, navController)
    }
    
    func setWindow(rootController: UIViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = rootController
    }
}

//final class PullRequestDetailFactorySpy: PullRequestDetailFactory, UserDetailFactory {
//    func makePullRequestDetailViewController(coordinator: PullRequestDetailCoordinatorProtocol,
//                                             viewModelItem: PullRequestViewModelItem,
//                                             ownerName: String,
//                                             repoName: String) -> PullRequestDetailViewController {
//
//        return PullRequestDetailViewController(coordinator: <#T##PullRequestDetailCoordinatorProtocol#>, viewModel: <#T##PullRequestDetailsViewModel#>)
//    }
//
//    func makeUserDetailViewController(userName: String, coordinator: UserDetailCoordinator) -> UserDetailViewController {
//
//    }
//}

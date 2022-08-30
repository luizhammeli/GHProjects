//
//  UserDetailCoordinatorTests.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 29/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

@testable import GHProjects
import SafariServices

final class UserDetailCoordinatorTests: XCTestCase {
    func test_start_() {
        let (sut, spy) = makeSUT()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = spy
        
        sut.start()
        
        guard let navController = spy.presentedViewController as? UINavigationController else {
            return XCTFail("Expected UINavigationController as presented view controller")
        }

        XCTAssertEqual(navController.viewControllers.count, 1)
        XCTAssertEqual(navController.viewControllers.first is UserDetailViewController, true)
    }
    
    func test_closeViewController_() {
        let (sut, spy) = makeSUT()

        sut.start()        
        sut.closeViewController()
        
        XCTAssertTrue(spy.dismissWasCalled)
    }
    
    func test_goToProfile_() {
        let spy = NavigationControllerSpy()
        let url = makeURL()
        let (sut, _) = makeSUT(userDetailNavController: spy)

        sut.start()
        sut.goToProfile(stringUrl: url.description)

        XCTAssertEqual(spy.pushedControllers.count, 1)
        XCTAssertEqual(spy.pushedControllers.first is SFSafariViewController, true)
    }
}

private extension UserDetailCoordinatorTests {
    func makeSUT(userDetailNavController: UINavigationController = UINavigationController()) -> (UserDetailCoordinator, NavigationControllerSpy) {
        let navController = NavigationControllerSpy()
        let sut = UserDetailCoordinator(userName: "",
                                        factory: DependencyContainer(),
                                        navigationController: navController,
                                        userDetailRootNavigationController: userDetailNavController)
        return(sut, navController)
    }
}

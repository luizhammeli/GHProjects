//
//  TabbarCoordinatorTests.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 25/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

@testable import GHProjects

final class TabbarCoordinatorTests: XCTestCase {
    func test_start_shouldSetTabBarAsRootViewController() {
        let window = UIWindow()
        let sut = makeSUT(window: window)
        
        sut.start()
        
        XCTAssertTrue(window.rootViewController is GHTabBarController)
    }
    
    func test_start_shouldSetRepositoriesListAsFirstItem() {
        let window = UIWindow()
        let sut = makeSUT(window: window)
        
        sut.start()
        
        let tabBarController = window.rootViewController as? GHTabBarController
        let controller = tabBarController?.getTabItem(with: 0) as? RepositoriesListViewController
        XCTAssertNotNil(controller)
    }
    
    func test_start_shouldSetRepositoriesListAsSecondItem() {
        let window = UIWindow()
        let sut = makeSUT(window: window)
        
        sut.start()
        
        let tabBarController = window.rootViewController as? GHTabBarController
        let controller = tabBarController?.getTabItem(with: 1) as? FavoritesViewController
        XCTAssertNotNil(controller)
    }
}

private extension TabbarCoordinatorTests {
    func makeSUT(window: UIWindow = UIWindow()) -> TabbarCoordinator {
        let sut = TabbarCoordinator(window: window, factory: DependencyContainer())
        return sut
    }
}

fileprivate extension GHTabBarController {
    func getTabItem<T: UIViewController>(with index: Int) -> T? {
        let navController = viewControllers?[index] as? UINavigationController
        return navController?.viewControllers.first as? T
    }
}

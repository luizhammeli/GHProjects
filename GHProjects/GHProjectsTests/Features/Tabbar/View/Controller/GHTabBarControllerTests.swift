//
//  GHTabBarControllerTests.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 25/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import Foundation
import XCTest

@testable import GHProjects

final class GHTabBarControllerTests: XCTestCase {
    func test_init_shouldSetCorrectTintColor() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.tabBar.tintColor, UIColor.systemBlue)
    }
    
    func test_init_shouldSetCorrectAcessibilityIdentifies() {
        let sut = makeSUT()

        XCTAssertEqual(sut.view.accessibilityIdentifier, "ghTabBarControllerView")
    }
    
    func test_init_shouldSetCorrectControllers() {
        let controllers = [UIViewController(), UIViewController()]
        let sut = makeSUT(controllers: controllers)
        
        XCTAssertEqual(sut.viewControllers, controllers)
    }
}

private extension GHTabBarControllerTests {
    func makeSUT(controllers: [UIViewController] = []) -> GHTabBarController {
        let sut = GHTabBarController(viewControllers: controllers)
        return sut
    }
}

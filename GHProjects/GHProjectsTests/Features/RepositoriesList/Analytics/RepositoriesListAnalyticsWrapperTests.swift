//
//  RepositoriesListAnalyticsWrapperTests.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 20/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

@testable import GHProjects

final class RepositoriesListAnalyticsWrapperTests: XCTestCase {
    func test_trackFetchRepositories_shouldSendCorrectNumberOfTracks() {
        let (sut, manager) = makeSUT()
        
        sut.trackFetchRepositories(state: .loading)
        
        XCTAssertEqual(manager.receivedTracks.count, 1)
    }
    
    func test_trackFetchRepositories_shouldSendCorrectKeyTrack() {
        let (sut, manager) = makeSUT()
        
        sut.trackFetchRepositories(state: .loading)
        
        XCTAssertEqual(manager.receivedTracks.first?.key, "fetchRepositories")
    }
    
    func test_trackFetchRepositories_shouldSendCorrectTrackValue() {
        let (sut, manager) = makeSUT()
        
        sut.trackFetchRepositories(state: .loading)
        
        XCTAssertEqual(manager.receivedTracks.first?.values, ["state": "loading"])
    }
}

private extension RepositoriesListAnalyticsWrapperTests {
    func makeSUT() -> (DefaultRepositoriesListAnalyticsWrapper, AnalyticsManagerSpy) {
        let manager = AnalyticsManagerSpy()
        let sut = DefaultRepositoriesListAnalyticsWrapper(manager: manager)

        return (sut, manager)
    }
}

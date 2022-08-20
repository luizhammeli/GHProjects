//
//  FirebaeAnalyticsManager.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 20/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

@testable import GHProjects

final class FirebaeAnalyticsManagerTests: XCTestCase {
    typealias Completion = (key: String, value: [String: Any]?)
    
    func test_track_shouldSendOneEvent() {
        var receivedData: [Completion] = []
        let sut = FirebaeAnalyticsManager { receivedData.append(($0, $1)) }
        
        sut.track(key: "", value: nil)
        
        XCTAssertEqual(receivedData.count, 1)
    }
    
    func test_track_shouldSendCorrectData() {
        expectTrack(with: "TestKey", value: ["Teste Value": "Test Value Description"])
    }
    
    func test_track_shouldSendCorrectDataWithNilFieldValue() {
        expectTrack(with: "TestKey", value: nil)
    }
}

private extension FirebaeAnalyticsManagerTests {
    func expectTrack(with key: String,
                     value: [String: String]?,
                     file: StaticString = #filePath,
                     line: UInt = #line) {
        var receivedData: [Completion] = []
        let sut = FirebaeAnalyticsManager { receivedData.append(($0, $1)) }
        
        sut.track(key: key, value: value)
        
        guard let data = receivedData.first else {
            XCTFail("Exptected one event sended")
            return
        }
        
        XCTAssertEqual(data.key, key, file: file, line: line)
        XCTAssertEqual(data.value as? [String: String], value, file: file, line: line)
    }
}

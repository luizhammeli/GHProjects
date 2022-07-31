//
//  XCTestCase+MemoryLeak.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 26/07/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

extension XCTestCase {
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line:  line)
        }
    }
}

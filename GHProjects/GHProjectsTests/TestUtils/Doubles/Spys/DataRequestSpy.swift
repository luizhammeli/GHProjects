//
//  DataRequestSpy.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 03/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import Foundation

@testable import GHProjects

final class DataRequestSpy: DataRequest {
    private var receivedMessages: [(url: URL, completion: (Result<Data, GHError>) -> Void)] = []
    var cancelCalled: (() -> Void)?
    
    var urls: [String] {
        receivedMessages.map { $0.url.description }
    }

    func cancel() {
        cancelCalled?()
    }
    
    func responseData(url: URL, completion: @escaping (Result<Data, GHError>) -> Void) -> NetworkRequesTask {
        receivedMessages.append((url: url, completion: completion))
        return NetworkRequesTaskSpy()
    }
    
    func complete(with result: Result<Data, GHError>, at index: Int = 0) {
        receivedMessages[index].completion(result)
    }
}

class NetworkRequesTaskSpy: NetworkRequesTask {
    var isCanceled: Bool = true
    func cancel() {}
}

//
//  PullRequestServiceSpy.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 17/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import Foundation

@testable import GHProjects

final class PullRequestServiceSpy: PullRequestService {
    var completions: [(Result<[PullRequest], GHError>, Bool) -> Void] = []
    var requestData = [(owner: String, repository: String)]()

    func fetchPullRequestData(_ owner: String,
                              repository: String,
                              completion: @escaping (Result<[PullRequest], GHError>, Bool) -> Void) {
        completions.append(completion)
        requestData.append((owner, repository))
    }
    
    func complete(with result: Result<[PullRequest], GHError>, hasMoreData: Bool = true, at index: Int = 0) {
        completions[index](result, hasMoreData)
    }
}

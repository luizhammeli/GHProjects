//
//  RepositoryService.swift
//  ios-base-architecture
//
//  Created by Luiz on 24/02/20.
//  Copyright © 2020 PEBMED. All rights reserved.
//

import Foundation

protocol RepositoryService {
    typealias Result = Swift.Result<SearchRepositories, GHError>

    func fetchRepositoriesData(completion: @escaping (Result, Bool) -> Void)
}

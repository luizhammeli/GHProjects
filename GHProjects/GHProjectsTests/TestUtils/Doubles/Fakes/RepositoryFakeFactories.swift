//
//  RepositoryFakeFactories.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 26/07/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import UIKit
@testable import GHProjects

func makeRepository(id: Int = 0, description: String? = "Test Description") -> (model: Repository, viewModel: RepositoryViewModelItem) {
    let model = Repository(id: id,
                           name: "Test Repo \(id)",
                           fullName: "Full Name Test Repo",
                           description: description,
                           owner: .init(id: 10, login: "Test Owner", avatarUrl: nil),
                           stargazersCount: 12,
                           forksCount: 13,
                           openIssuesCount: 14)
    
    let viewModel = RepositoryViewModelItem(name: "Test Repo \(id)",
                                            description: "Test Description",
                                            avatarUrl: nil,
                                            stargazersCount: 12,
                                            forksCount: 13,
                                            openIssuesCount: 14,
                                            ownerName: "Test Owner",
                                            login: "Test Owner")
    return (model, viewModel)
}

func makeRepositoryItems() -> Repository {
    return Repository(id: 0,
                      name: "",
                      fullName: nil,
                      description: nil,
                      owner: .init(id: 0, login: "", avatarUrl: nil),
                      stargazersCount: 0,
                      forksCount: 0,
                      openIssuesCount: 0)
}

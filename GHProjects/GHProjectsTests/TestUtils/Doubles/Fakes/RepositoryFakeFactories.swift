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

func makeFakePullRequest(id: Int = 1, createdAt: Date? = nil) -> PullRequest {
    return PullRequest(id: id,
                       number: 10,
                       title: "teste",
                       body: nil,
                       createdAt: createdAt,
                       user: makeUser(),
                       base: makeBase())
}

func makeFakePullRequestDetail(id: Int = 1, createdAt: Date? = nil) -> (model: PullRequestDetail,
                                                                        viewModel: PullRequestDetailViewModelItem) {
    let model = PullRequestDetail(id: id,
                                  number: 2,
                                  changedFiles: 3,
                                  additions: 4,
                                  deletions: 5,
                                  title: "Teste",
                                  state: "Test State",
                                  body: "Test Body",
                                  createdAt: createdAt,
                                  base: makeBase(),
                                  head: makeBase())
    
    let atributtedString = NSMutableAttributedString(
        string: "+\(model.additions) ",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]
    )
    atributtedString.append(NSAttributedString(
        string: " -\(model.deletions)",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed]
        )
    )
    
    let viewModel = PullRequestDetailViewModelItem(number: "#\(model.number)", changedFiles: "\(model.changedFiles) files changed",
                                                   title: "Teste",
                                                   state: "Test State",
                                                   body: "Test Body",
                                                   createdAt: Date().description,
                                                   baseAvatarUrl: model.base.repo.owner.avatarUrl ?? "",
                                                   headAvatarUrl: model.head.repo.owner.avatarUrl ?? "",
                                                   fullName: model.base.repo.fullName!,
                                                   additionsDeletions: atributtedString,
                                                   baseBranchName: model.base.ref,
                                                   headBranchName: model.base.label,
                                                   userName: model.head.repo.owner.login)
    
    return (model, viewModel)
}

func  makePullRequestViewModelItem(title: String = "Test Title") -> PullRequestViewModelItem {
    return PullRequestViewModelItem(login: "", number: 0, title: title, body: nil, createdAt: "", avatarUrl: nil)
}

func makeFakePullRequestModels(title: String = "Test Title", createdAt: Date? = Date(), body: String? = nil) -> (PullRequest, PullRequestViewModelItem) {
    let pr = PullRequest(id: 0,
                         number: 10,
                         title: title,
                         body: body,
                         createdAt: createdAt,
                         user: makeUser(),
                         base: makeBase())
    
    let viewModel = PullRequestViewModelItem(login: pr.user.login,
                                             number: pr.number,
                                             title: pr.title,
                                             body: pr.body,
                                             createdAt: pr.createdAt?.convertToMonthDayYearFormat() ?? "",
                                             avatarUrl: nil)
    return (pr, viewModel)
}

func makeUser(id: Int = 1, createdAt: Date? = nil) -> User {
    return User(id: id,
                login: "login",
                avatarUrl: nil,
                company: nil,
                name: nil,
                location: nil,
                bio: nil,
                publicRepos: nil,
                publicGists: nil,
                htmlUrl: makeURL().description,
                following: nil,
                followers: nil,
                createdAt: createdAt)
}

func makeBase() -> Base {
    return .init(label: "label", ref: "ref", repo: makeRepository().model)
}

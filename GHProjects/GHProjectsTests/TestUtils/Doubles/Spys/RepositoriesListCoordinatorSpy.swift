//
//  RepositoriesListCoordinatorSpy.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 28/07/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import Foundation
@testable import GHProjects

final class RepositoriesListCoordinatorSpy: RepositoriesListCoordinatorProtocol {
    var sendedViewModels = [RepositoryViewModelItem]()

    func goToPullRequestList(viewModelItem: RepositoryViewModelItem) {
        sendedViewModels.append(viewModelItem)
    }
}

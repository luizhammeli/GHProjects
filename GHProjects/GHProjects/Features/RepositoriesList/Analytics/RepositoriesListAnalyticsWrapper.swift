//
//  RepositoriesListAnalyticsWrapper.swift
//  GHProjects
//
//  Created by Luiz Hammerli on 19/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import Foundation

protocol RepositoriesListAnalyticsWrapper {
    func trackFetchRepositories(state: RepositoriesListAnalyticsFetchState)
}

enum RepositoriesListAnalyticsFetchState: String {
    case start
    case loading
    case success
    case error
}

final class DefaultRepositoriesListAnalyticsWrapper: RepositoriesListAnalyticsWrapper {
    let manager: AnalyticsManager

    init(manager: AnalyticsManager) {
        self.manager = manager
    }

    func trackFetchRepositories(state: RepositoriesListAnalyticsFetchState) {
        manager.track(key: "fetchRepositories", value: ["state": state.rawValue])
    }
}

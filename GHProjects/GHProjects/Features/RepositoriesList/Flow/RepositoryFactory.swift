//
//  RepositoryFactory.swift
//  ios-base-architecture
//
//  Created by Jonathan Bijos on 13/03/20.
//  Copyright © 2020 PEBMED. All rights reserved.
//

protocol RepositoryFactory {
    func makeRepositoriesListViewController(coordinator: RepositoriesListCoordinatorProtocol,
                                            service: RepositoryService,
                                            analyticsWrapper: RepositoriesListAnalyticsWrapper) -> RepositoriesListViewController
}

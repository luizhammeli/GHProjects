//
//  RepositoryViewModel.swift
//  ios-base-architecture
//
//  Created by Luiz on 24/02/20.
//  Copyright © 2020 PEBMED. All rights reserved.
//

import UIKit

protocol RepositoryViewModel {
    var hasMoreData: Bool { get }
    
    func fetchRepositories(completion: @escaping (Bool, String?) -> Void)
    func getRepositoryViewModelItem(with indexPath: IndexPath) -> RepositoryViewModelItem
    func getRepositoryViewModelNumberOfItems() -> Int
}

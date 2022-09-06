//
//  DependencyContainer.swift
//  ios-base-architecture
//
//  Created by Jonathan Bijos on 13/03/20.
//  Copyright © 2020 PEBMED. All rights reserved.
//

import DependencyCompositionContainer
import UIKit

final class DependencyContainer {}

extension DependencyContainer: DependencyCompositionContainer {
    func route(to id: String, with param: [String: Any]?, controller: UIViewController) {
        switch id {
        case "UserDetail":
            guard let id = param?["id"] as? String, let navController = controller as? UINavigationController else { return }
            UserDetailCoordinator(userName: id, factory: self, navigationController: navController).start()
        default:
            return
        }
    }
}

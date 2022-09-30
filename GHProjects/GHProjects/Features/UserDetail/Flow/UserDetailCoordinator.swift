//
//  UserDetailCoordinator.swift
//  ios-base-architecture
//
//  Created by Luiz on 14/03/20.
//  Copyright © 2020 PEBMED. All rights reserved.
//

import SafariServices
import DependencyCompositionContainer
import UIKit

protocol UserDetailCoordinatorProtocol: AnyObject {
    func goToProfile(stringUrl: String)
    func closeViewController()
}

final class UserDetailCoordinator: Coordinator, NewCoordinator {
    private let factory: UserDetailFactory
    private let userName: String
    private var navigationController: UINavigationController
    private weak var userDetailRootNavigationController: UINavigationController?

    init(userName: String, factory: UserDetailFactory,
         navigationController: UINavigationController,
         userDetailRootNavigationController: UINavigationController = UINavigationController()) {
        self.factory = factory
        self.userName = userName
        self.navigationController = navigationController
        self.userDetailRootNavigationController = userDetailRootNavigationController
    }

    func start() {
        let controller = factory.makeUserDetailViewController(userName: userName, coordinator: self)

        //userDetailRootNavigationController?.viewControllers = [controller]

        navigationController.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }

    deinit {
        print("DEINIT UserDetailCoordinatorProtocol")
    }
}

// MARK: - UserDetailCoordinatorProtocol
extension UserDetailCoordinator: UserDetailCoordinatorProtocol {
    func goToProfile(stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }
        let safariController = SFSafariViewController(url: url)
        guard let nav = navigationController.presentedViewController as? UINavigationController else { return }
        let coord = UserDetailCoordinator(userName: userName, factory: factory, navigationController: nav)
        coord.start()
        //nav.pushViewController(nav, animated: true)
    }

    func closeViewController() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

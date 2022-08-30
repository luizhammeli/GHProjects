//
//  NavigationControllerSpy.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 26/07/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import UIKit

final class NavigationControllerSpy: UINavigationController {
    var pushedControllers: [UIViewController] = []
    var dismissWasCalled = false
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        pushedControllers.append(viewController)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissWasCalled = true
    }
}

//
//  DependencyCompositionContainer.swift
//  DependencyCompositionContainer
//
//  Created by Luiz Hammerli on 05/09/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import Foundation
import UIKit

public protocol NewCoordinator {
    func start()
}

public protocol DependencyCompositionContainer {
    func route(to id: String, with param: [String: Any]?, controller: UIViewController)
}

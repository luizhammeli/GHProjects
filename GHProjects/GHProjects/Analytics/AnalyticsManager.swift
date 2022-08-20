//
//  AnalyticsManager.swift
//  GHProjects
//
//  Created by Luiz Hammerli on 19/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import Foundation

protocol AnalyticsManager: AnyObject {
    func track(key: String, value: [String: String]? )
}


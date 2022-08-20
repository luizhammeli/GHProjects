//
//  MainAnalyticsManager.swift
//  GHProjects
//
//  Created by Luiz Hammerli on 20/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import Foundation

final class CustomAnalyticsManager: AnalyticsManager {
    func track(key: String, value: [String: String]?) {}
}

final class MainAnalyticsManager: AnalyticsManager {
    static let shared = MainAnalyticsManager(
        managers: [FirebaeAnalyticsManager(), CustomAnalyticsManager()]
    )

    let managers: [AnalyticsManager]

    init(managers: [AnalyticsManager]) {
        self.managers = managers
    }

    func track(key: String, value: [String: String]?) {
        managers.forEach { $0.track(key: key, value: value) }
    }
}

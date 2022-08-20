//
//  FirebaeAnalyticsManager.swift
//  GHProjects
//
//  Created by Luiz Hammerli on 19/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import Firebase

final class FirebaeAnalyticsManager: AnalyticsManager {
    let logEvent: (String, [String: Any]?) -> Void

    init(logEvent: @escaping (String, [String: Any]?) -> Void = Analytics.logEvent) {
        self.logEvent = logEvent        
    }

    func track(key: String, value: [String: String]?) {
        logEvent(key, value)
    }
}

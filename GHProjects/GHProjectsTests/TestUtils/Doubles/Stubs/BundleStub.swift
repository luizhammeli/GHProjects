//
//  BundleStub.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 07/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import Foundation

class BundleStub: Bundle {
    var receivedKeys: [String] = []
    let url: String
    
    init(url: String) {
        self.url = url
        super.init()
    }
    
    override func object(forInfoDictionaryKey key: String) -> Any? {
        receivedKeys.append(key)
        return url
    }
}

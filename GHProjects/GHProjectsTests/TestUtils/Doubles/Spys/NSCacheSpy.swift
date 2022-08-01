//
//  NSCacheSpy.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 31/07/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import UIKit

final class NSCacheSpy: NSCache<NSString, UIImage> {
    private let fakeImage: UIImage?
    var requestedKeys: [NSString] = []
    var sendedImages: [String] = []
    
    init(fakeImage: UIImage? = nil) {
        self.fakeImage = fakeImage
    }
    
    override func object(forKey key: NSString) -> UIImage? {
        requestedKeys.append(key)
        return fakeImage
    }
    
    override func setObject(_ obj: UIImage, forKey key: NSString) {
        sendedImages.append(String(key))
    }
}

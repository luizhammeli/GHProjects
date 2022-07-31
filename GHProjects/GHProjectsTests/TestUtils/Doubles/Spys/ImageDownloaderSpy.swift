//
//  ImageDownloaderSpy.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 29/07/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import UIKit
@testable import GHProjects

final class ImageDownloaderSpy: ImageDownloader {
    var messages = [(stringURL: String, completion: (Result<UIImage, GHImageError>) -> Void)]()
    
    var urls: [String] {
        messages.map( { $0.stringURL } )
    }
    
    func download(stringURL: String, completion: @escaping (Result<UIImage, GHImageError>) -> Void) {
        messages.append((stringURL: stringURL, completion: completion))
    }
    
    func complete(with result: Result<UIImage, GHImageError>, at index: Int = 0) {
        messages[index].completion(result)
    }
}

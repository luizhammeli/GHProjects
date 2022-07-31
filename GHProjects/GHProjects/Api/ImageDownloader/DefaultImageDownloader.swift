//
//  DefaultImageDownloader.swift
//  GHProjects
//
//  Created by Jonathan Bijos on 27/03/20.
//  Copyright © 2020 PEBMED. All rights reserved.
//

import UIKit

struct DefaultImageDownloader: ImageDownloader {
    private let cache: NSCache<NSString, UIImage>
    private let urlSession: URLSession

    init(cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>(),
         urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
        self.cache = cache
    }

    func download(stringURL: String, completion: @escaping (Result<UIImage, GHImageError>) -> Void) {
        if let image = cache.object(forKey: NSString(string: stringURL)) {
            completion(.success(image))
            return
        }

        guard let url = URL(string: stringURL) else {
            completion(.failure(GHImageError.invalidURL))
            return
        }

        let dataTask = urlSession.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data, let image = UIImage(data: data) else {
                completion(.failure(GHImageError.fetch))
                return
            }

            self.cache.setObject(image, forKey: NSString(string: stringURL))
            completion(.success(image))
        }
        dataTask.resume()
    }
}

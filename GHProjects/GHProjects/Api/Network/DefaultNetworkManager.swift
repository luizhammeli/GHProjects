//
//  DefaultNetworkManager.swift
//  ios-base-architecture
//
//  Created by Luiz on 21/02/20.
//  Copyright © 2020 PEBMED. All rights reserved.
//

import UIKit

final class DefaultNetworkManager: NetworkManager {
    private let request: DataRequest
    private let cache = NSCache<NSString, UIImage>()
    private let bundle: Bundle
    private lazy var baseUrl: String = {
        guard let url = bundle.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("No such url as BASE_URL in info.plist")
        }
        return url
    }()

    init(request: DataRequest = DefaultDataRequest(), bundle: Bundle = Bundle.main) {
        self.request = request
        self.bundle = bundle
    }

    func fetch(urlString: String,
               method: HTTPMethod,
               parameters: [String: Any],
               headers: [String: String],
               completion: @escaping (Result<Data, GHError>) -> Void) {
        guard let url = URL(string: "\(baseUrl)\(urlString)"), !urlString.isEmpty else {
            completion(.failure(GHError.invalidURL))
            return
        }

        request.responseData(url: url) { result in completion(result) }
    }

    deinit {
        print("DEINIT DefaultNetworkManager")
        request.cancel()
    }
}

//
//  DefaultDataRequest.swift
//  ios-base-architecture
//
//  Created by Jonathan Bijos on 10/03/20.
//  Copyright © 2020 PEBMED. All rights reserved.
//

import Foundation

final class DefaultDataRequest: DataRequest {
    // MARK: - Properties
    private let session: URLSession

    var tasks: [URLSessionTask?] = []

    // MARK: - Init
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    // MARK: - Functions
    func cancel() {        
        tasks.forEach { $0?.cancel() }
    }

    func responseData(url: URL, completion: @escaping (Result<Data, GHError>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(GHError.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(GHError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(GHError.invalidData))
                return
            }

            completion(.success(data))
        }
        task.resume()
        tasks.append(task)
    }
}

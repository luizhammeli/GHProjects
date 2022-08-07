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

    private var tasks: [NetworkRequesTask] = []

    // MARK: - Init
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    // MARK: - Functions
    func cancel() {
        tasks.forEach { $0.cancel() }
    }

    @discardableResult
    func responseData(url: URL, completion: @escaping (Result<Data, GHError>) -> Void) -> NetworkRequesTask {
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(GHError.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(GHError.invalidResponse))
                return
            }

            guard let data = data, !data.isEmpty else {
                completion(.failure(GHError.invalidData))
                return
            }

            completion(.success(data))
        }
        task.resume()

        let networkTask = DefaultNetworkRequestTask(task: task)
        tasks.append(networkTask)

        return networkTask
    }
}

protocol NetworkRequesTask {
    var isCanceled: Bool { get set }

    func cancel()
}

class DefaultNetworkRequestTask: NetworkRequesTask {
    private let task: URLSessionTask
    var isCanceled: Bool = false

    init(task: URLSessionTask) {
        self.task = task
    }

    func cancel() {
        isCanceled = true
        task.cancel()
    }
}

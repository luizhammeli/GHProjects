//
//  NetworkManagerSpy.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 26/07/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import Foundation
@testable import GHProjects

final class NetworkManagerSpy: NetworkManager {
    private var completions: [(url: String, completion: (Result<Data, GHError>) -> Void)] = []
    var headers: [[String: String]] = []
    var method: HTTPMethod?
    
    var urls: [String] {
        completions.map { $0.url }
    }
    
    func fetch(urlString: String,
               method: HTTPMethod,
               parameters: [String: Any],
               headers: [String: String],
               completion: @escaping (Result<Data, GHError>) -> Void) {
        
        completions.append((urlString, completion))
        self.headers.append(headers)
        self.method = method
    }
    
    func complete(with result: Result<Data, GHError>, at index: Int = 0) {
        completions[index].completion(result)
    }
}

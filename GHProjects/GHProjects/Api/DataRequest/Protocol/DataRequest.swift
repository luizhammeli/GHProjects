//
//  DataRequest.swift
//  ios-base-architecture
//
//  Created by Jonathan Bijos on 10/03/20.
//  Copyright © 2020 PEBMED. All rights reserved.
//

import Foundation

protocol DataRequest {
    func cancel()
    func responseData(url: URL, completion: @escaping (Result<Data, GHError>) -> Void)
}

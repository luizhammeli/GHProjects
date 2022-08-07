//
//  GenericTestFactories.swift
//  GHProjectsTests
//
//  Created by Luiz Hammerli on 07/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import UIKit

func makeURL() -> URL {
    URL(string: "https://www.test.com")!
}

func makeError() -> NSError {
    NSError(domain: "", code: 1)
}

func makeImageData() -> (data: Data, image: UIImage) {
    let image = UIImage.make(withColor: .red)
    return (image.pngData()!, image)
}

func makeHttpURLResponse(with statusCode: Int, for url: URL = makeURL()) -> HTTPURLResponse {
    return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func makeFakeData() -> Data {
    "Test_Data".data(using: .utf8)!
}

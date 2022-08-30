//
//  DefaultUserDetailServiceTests.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 29/08/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

@testable import GHProjects

final class DefaultUserDetailServiceTests: XCTestCase {
    func test_fetchUserDetailData_shouldSendCorrectURLDetail() {
        let fakeUserName = "test"
        let (sut, spy) = makeSUT()

        sut.fetchUserDetailData(userName: fakeUserName, completionHandler: { _ in })
                
        XCTAssertEqual(spy.urls, ["users/\(fakeUserName)"])
        XCTAssertEqual(spy.method, .get)
    }
    
    func test_fetchUserDetailData_shouldFailIfServiceCompletesWithFailureResult() {
        let (sut, spy) = makeSUT()

        var receivedData: Result<User, GHError>?

        sut.fetchUserDetailData(userName: "", completionHandler: { receivedData = $0 })
        spy.complete(with: .failure(.genericError))
                
        XCTAssertEqual(receivedData, .failure(.genericError))
    }
    
    func test_fetchUserDetailData_shouldSucceedIfServiceCompletesWithSuccess() {
        let (sut, spy) = makeSUT()
        let expectedData = makeUserData()
        var receivedData: Result<User, GHError>?

        sut.fetchUserDetailData(userName: "", completionHandler: { receivedData = $0 })
        spy.complete(with: .success(expectedData.data))
                
        XCTAssertEqual(receivedData, .success(expectedData.user))
    }
    
    func test_fetchUserDetailData_shouldFailIfServiceCompletesWithSuccessWithInvalidData() {
        let (sut, spy) = makeSUT()
        var receivedData: Result<User, GHError>?

        sut.fetchUserDetailData(userName: "", completionHandler: { receivedData = $0 })
        spy.complete(with: .success(makeFakeData()))
                
        XCTAssertEqual(receivedData, .failure(.invalidData))
    }
}

private extension DefaultUserDetailServiceTests {
    func makeSUT() -> (DefaultUserDetailService, NetworkManagerSpy) {
        let networkManagerSpy = NetworkManagerSpy()
        let sut = DefaultUserDetailService(networkManager: networkManagerSpy)
        
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: networkManagerSpy)

        return (sut, networkManagerSpy)
    }
    
    func makeUserData() -> (user: User, data: Data){
        let user = makeUser()
        return (user, try! JSONEncoder().encode(user))
    }
}

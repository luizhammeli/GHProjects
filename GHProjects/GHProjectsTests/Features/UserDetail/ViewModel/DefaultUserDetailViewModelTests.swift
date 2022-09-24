//
//  DefaultUserDetailViewModelTests.swift
//  GHProjectsTests
//
//  Created by Luiz Diniz Hammerli on 02/09/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import XCTest

@testable import GHProjects

final class DefaultUserDetailViewModelTests: XCTestCase {
    func test_fetchUserDetail_shouldSendCorrectUsername() {
        let fakeUsername = "Username"
        let (sut, spy) = makeSUT(userName: fakeUsername)
        
        sut.fetchUserDetail { _, _ in }
                
        XCTAssertEqual(spy.usernames, [fakeUsername])
    }
    
    func test_fetchUserDetail_shouldFailIfServiceCompletesWithError() {
        let (sut, spy) = makeSUT()
        var receivedData: (Bool, String?)?
        
        sut.fetchUserDetail { receivedData = ($0, $1) }
        spy.complete(with: .failure(.genericError))
                
        XCTAssertEqual(receivedData?.0, false)
        XCTAssertEqual(receivedData?.1, "Error to processing your request. Please try again later.")
    }
    
    func test_fetchUserDetail_shouldSucceedIfServiceCompletesWithSuccess() {
        let (sut, spy) = makeSUT()
        var receivedData: (Bool, String?)?
        
        sut.fetchUserDetail { receivedData = ($0, $1) }
        spy.complete(with: .success(makeUser()))
                
        XCTAssertEqual(receivedData?.0, true)
        XCTAssertNil(receivedData?.1)
    }
    
    func test_fetchUserDetail_shouldNotCompleteIfInstanceHasBeenDealocated() {
        let spy = UserDetailServiceSpy()
        var sut: DefaultUserDetailViewModel? = DefaultUserDetailViewModel(userName: "", service: spy)
        var receivedData: (Bool, String?)?
        
        sut?.fetchUserDetail { receivedData = ($0, $1) }
        sut = nil
        spy.complete(with: .success(makeUser()))
                        
        XCTAssertNil(receivedData)
    }
    
    func test_fetchUserDetail_shouldSetCorrectViewModelData() {
        let (sut, spy) = makeSUT()
        
        sut.fetchUserDetail { _, _ in }
        spy.complete(with: .success(makeUser()))
                
        XCTAssertEqual(sut.getUserViewModelItem()?.login, "login")
        XCTAssertEqual(sut.getUserViewModelItem()?.company, "Not Available")
    }
}

private extension DefaultUserDetailViewModelTests {
    func makeSUT(userName: String = "") -> (DefaultUserDetailViewModel, UserDetailServiceSpy) {
        let serviceSpy = UserDetailServiceSpy()
        let sut = DefaultUserDetailViewModel(userName: userName, service: serviceSpy)
        
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: serviceSpy)
        
        return (sut, serviceSpy)
    }
}

final class UserDetailServiceSpy: UserDetailService {
    typealias ServiceResult = Result<User, GHError>
    
    private var receivedMessages = [(username: String, completion: (ServiceResult) -> Void)]()
    
    var usernames: [String] {
        receivedMessages.map { $0.username }
    }
    
    func fetchUserDetailData(userName: String, completionHandler: @escaping (ServiceResult) -> Void) {
        receivedMessages.append((username: userName, completion: completionHandler))
    }
    
    func complete(with result: ServiceResult, at index: Int = 0) {
        receivedMessages[index].completion(result)
    }
}

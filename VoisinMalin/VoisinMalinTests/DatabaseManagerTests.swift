//
//  DatabaseManagerTests.swift
//  VoisinMalinTests
//
//  Created by vincent on 12/10/2021.
//

import XCTest
@testable import VoisinMalin

final class DatabaseManagerTests: XCTestCase {


    private class DatabaseManagers: DatabaseType {
        
        private let userResult: Result<[String: Any], Error>
        
        init(_ userData: [String: Any]) {
            self.userResult = .success(userData)
        }

        init(_ error: Error) {
            self.userResult = .failure(error)
        }
        
        func getUserData(with uid: String, callback: @escaping (Result<[String : Any], Error>) -> Void) {
            callback(userResult)
        }


    }
    
    
    enum TestError: Error {
        case invalidUID
    }
    
    
    func testGetUserDataMethod_WhenTheUIDIsCorrect_ThenShouldReturnUserData() {
        let sut: DatabaseManager = DatabaseManager(database: DatabaseManagers(["uid": "NyeVduglGkQAgldAgG5durdJAer2", "username": "A Username"]))
        let uid: String = "NyeVduglGkQAgldAgG5durdJAer2"
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getUserData(with: uid) { result in
            guard case .success(let userData) = result else {
                XCTFail("Get User Data Method Success Tests Fails")
                return
            }
            XCTAssertTrue(userData as! [String: String] == ["uid": "NyeVduglGkQAgldAgG5durdJAer2", "username": "A Username"])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetUserDataMethod_WhenTheUIDIsIncorrect_ThenShouldReturnAnError() {
        let sut: DatabaseManager = DatabaseManager(database: DatabaseManagers(TestError.invalidUID))
        let uid: String = "invalidUid"
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getUserData(with: uid) { result in
            guard case .failure(let error) = result else {
                XCTFail("Get User Data Method Success Tests Fails")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}

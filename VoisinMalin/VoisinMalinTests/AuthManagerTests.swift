//
//  AuthManagerTests.swift
//  VoisinMalinTests
//
//  Created by vincent on 12/10/2021.
//

import XCTest
@testable import VoisinMalin

final class AuthManagerTests: XCTestCase {
    
    private class AuthTests: AuthType {
        
        var userMail: String? { return isSuccess ? "123@123.fr" : nil }
        
        private let isSuccess: Bool
        
        var currentUID: String? { return isSuccess ? "NyeVduglGkQAgldAgG5durdJAer2" : nil }
        
        init(_ isSuccess: Bool) {
            self.isSuccess = isSuccess
        }
        
        func signIn(email: String, password: String, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }

        func signUp(userName: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }

        func signOut(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }

        func isUserConnected(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
    }
    
    // Tests
    
    func testCurrentUID_WhenTheUserIsConnected_ThenShouldReturnAValue() {
        let sut: AuthService = AuthService(auth: AuthTests(true))
        let expectedUID: String = "NyeVduglGkQAgldAgG5durdJAer2"
        XCTAssertTrue(sut.currentUID! == expectedUID)
    }
    
    func testUserMail_WhenTheUserIsConnected_ThenShouldReturnAValue() {
        let sut: AuthService = AuthService(auth: AuthTests(true))
        let expectedMail: String = "123@123.fr"
        XCTAssertTrue(sut.userMail! == expectedMail)
    }

    func testSignInMethod_WhenTheUserEnterCorrectData_ThenShouldConnectTheUser() {
        let sut: AuthService = AuthService(auth: AuthTests(true))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.signIn(email: "CorrectMail", password: "CorrectPassword") { isSuccess in
            XCTAssertTrue(isSuccess == true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignInMethod_WhenTheUserEnterIncorrectData_ThenShouldNotConnectTheUser() {
        let sut: AuthService = AuthService(auth: AuthTests(false))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.signIn(email: "IncorrectMail", password: "IncorrectPassword") { isSuccess in
            XCTAssertTrue(isSuccess == false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignUpMethod_WhenTheUserEnterCorrectData_ThenShouldCreateTheUser() {
        let sut: AuthService = AuthService(auth: AuthTests(true))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.signUp(userName: "Username", email: "Email", password: "Password") { isSuccess in
            XCTAssertTrue(isSuccess == true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSignUpMethod_WhenTheUserEnterIncorrectData_ThenShouldNotCreateTheUser() {
        let sut: AuthService = AuthService(auth: AuthTests(false))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.signUp(userName: "Username", email: "Email", password: "") { isSuccess in
            XCTAssertTrue(isSuccess == false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSignOutMethod_WhenTheUserWantsToBeDisconnected_ThenTheUserShouldBeDisconnected() {
        let sut: AuthService = AuthService(auth: AuthTests(true))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.signOut { isSuccess in
            XCTAssertTrue(isSuccess == true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSignOutMethod_WhenTheUserWantsToBeDisconnected_ThenTheUserShouldNotBeDisconnected() {
        let sut: AuthService = AuthService(auth: AuthTests(false))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.signOut { isSuccess in
            XCTAssertTrue(isSuccess == false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testIsUserConnectedMethod_WhenTheUserIsConnected_ThenTheListenerShouldNotifyAConnectedUser() {
        let sut: AuthService = AuthService(auth: AuthTests(true))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.isUserConnected { isSuccess in
            XCTAssertTrue(isSuccess == true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testIsUserConnectedMethod_WhenTheUserIsDisonnected_ThenTheListenerShouldNotifyADisconnectedUser() {
        let sut: AuthService = AuthService(auth: AuthTests(false))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.isUserConnected { isSuccess in
            XCTAssertTrue(isSuccess == false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}

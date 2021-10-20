//
//  VoisinMalinTests.swift
//  VoisinMalinTests
//
//  Created by vincent on 03/07/2021.
//

import XCTest
@testable import VoisinMalin

class VoisinMalinTests: XCTestCase {

    func testGivenEmptyValue_WhenAddedValidEmail_ThenReturnTrue() {
        let validEmail =  "test.test@test.fr"

        let value = TestValues.validEmailAdress(emailAdressString: validEmail)

        XCTAssertTrue(value)
    }

    func testGivenEmptyValue_WhenAddedInvalidEmail_ThenReturnFalse() {
        let invalidEmail =  "test.test.test.fr"

        let value = TestValues.validEmailAdress(emailAdressString: invalidEmail)

        XCTAssertFalse(value)
    }
    
    ///  Corect Pasword : 8 caracters, 1 lower, 1 uper, 1 number
    func testGivenEmptyValue_WhenAddedValidPassword_ThenReturnTrue() {
        let validPassword = "enfinlafindeceP12"

        let value = TestValues.isValidPassword(password: validPassword)

        XCTAssertTrue(value)
    }
    
    ///  Corect Pasword : 8 caracters, 1 lower, 1 uper,1 number
    func testGivenEmptyValue_WhenAddedInvalidPassword_ThenReturnTrue() {
        let invalidPassword = "enfinlafindecep12"

        let value = TestValues.isValidPassword(password: invalidPassword)

        XCTAssertFalse(value)
    }
}

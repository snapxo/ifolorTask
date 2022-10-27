//
//  ifolorMVVMTests.swift
//  ifolorMVVMTests
//
//  Created by Arthur Gerster on 26.10.22.
//

import XCTest
@testable import ifolorMVVM

final class ifolorMVVMTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testValidation() throws {
        let sut = RegistrationViewModel()
        sut.name = "Valid Name"
        sut.email = "invalid.mail"
        sut.birthdate = Date.date(with: 1, month: 9, year: 1994)!
        XCTAssert(sut.isValid == false)
        sut.name = " "
        sut.email = "valid.mail@test.com"
        sut.birthdate = Date.date(with: 1, month: 9, year: 1994)!
        XCTAssert(sut.isValid == false)
        sut.name = "Valid Name"
        sut.email = "valid.mail@test.com"
        sut.birthdate = Date.date(with: 1, month: 9, year: 2022)!
        XCTAssert(sut.isValid == false)
        sut.name = "Valid Name"
        sut.email = "valid.mail@test.com"
        sut.birthdate = Date.date(with: 1, month: 9, year: 1994)!
        XCTAssert(sut.isValid == true)
    }

}

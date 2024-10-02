//
//  TwitterURLConstructorTests.swift
//  Github Users
//
//  Created by Ram Kumar on 02/10/24.
//

import XCTest
@testable import Github_Users

class TwitterURLConstructorTests: XCTestCase {

    func testURLForValidUsername() {
        let username = "user123"
        let expectedURL = URL(string: "https://x.com/user123")
        let resultURL = TwitterURLConstructor.url(for: username)
        XCTAssertEqual(resultURL, expectedURL, "The generated URL for a valid username is incorrect.")
    }
    
    func testURLForEmptyUsername() {
        let username = ""
        let resultURL = TwitterURLConstructor.url(for: username)
        XCTAssertNil(resultURL, "The URL should be nil for an empty username.")
    }
    
    func testURLForUsernameWithSpaces() {
        let username = "user name"
        let expectedURL = URL(string: "https://x.com/user%20name")
        let resultURL = TwitterURLConstructor.url(for: username)
        XCTAssertEqual(resultURL, expectedURL, "The generated URL for a username with spaces is incorrect.")
    }
    
    func testURLForUsernameWithSpecialCharacters() {
        let username = "user@name"
        let expectedURL = URL(string: "https://x.com/user@name")
        let resultURL = TwitterURLConstructor.url(for: username)
        XCTAssertEqual(resultURL, expectedURL, "The generated URL for a username with special characters is incorrect.")
    }
}

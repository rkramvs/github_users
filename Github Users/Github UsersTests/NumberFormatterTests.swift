//
//  Github_UsersTests.swift
//  Github UsersTests
//
//  Created by Ram Kumar on 25/09/24.
//

import XCTest
@testable import Github_Users

final class NumberFormatterTests: XCTestCase {
    
    func testFormatNumber_withBillion() {
        let result = NumberFormat.formatNumber(2_500_000_000)
        XCTAssertEqual(result, "2.5b", "Expected formatted number to be '2.5b'")
    }
    
    func testFormatNumber_withMillion() {
        let result = NumberFormat.formatNumber(5_000_000)
        XCTAssertEqual(result, "5m", "Expected formatted number to be '5m'")
    }
    
    func testFormatNumber_withThousand() {
        let result = NumberFormat.formatNumber(1_200)
        XCTAssertEqual(result, "1.2k", "Expected formatted number to be '1.2k'")
    }
    
    func testFormatNumber_withLessThanThousand() {
        let result = NumberFormat.formatNumber(999)
        XCTAssertEqual(result, "999", "Expected formatted number to be '999'")
    }
    
    func testFormatNumber_withNegativeValues() {
        let result = NumberFormat.formatNumber(-1_500_000)
        XCTAssertEqual(result, "-1.5m", "Expected formatted number to be '-1.5m'")
    }
    
    func testFormatNumber_withZero() {
        let result = NumberFormat.formatNumber(0)
        XCTAssertEqual(result, "0", "Expected formatted number to be '0'")
    }
    
    func testFormatNumber_withSmallNumber() {
        let result = NumberFormat.formatNumber(0.123)
        XCTAssertEqual(result, "0.123", "Expected formatted number to be '0.123'")
    }
    
    func testFormatNumber_withLargeDecimal() {
        let result = NumberFormat.formatNumber(1234567.89)
        XCTAssertEqual(result, "1.23m", "Expected formatted number to be '1.23m'")
    }
    
}

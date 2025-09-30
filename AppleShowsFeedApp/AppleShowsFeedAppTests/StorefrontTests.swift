//
//  StorefrontTests.swift
//  AppleShowsFeedAppTests
//
//  Created by Oswaldo Maestra on 30/09/2025.
//

import XCTest
import AppleShowsFeedApp

final class StorefrontTests: XCTestCase {
    func test_allCases_returnsExpectedStorefronts() {
        XCTAssertEqual(Storefront.allCases, [.canada, .spain])
    }
    
    func test_id_matchesRawValue() {
        XCTAssertEqual(Storefront.canada.id, "ca")
        XCTAssertEqual(Storefront.spain.id, "es")
    }
    
    func test_displayName_returnsCorrectName() {
        XCTAssertEqual(Storefront.canada.displayName, "🇨🇦 Canada Store")
        XCTAssertEqual(Storefront.spain.displayName, "🇪🇸 Spain Store")
    }
}

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
}

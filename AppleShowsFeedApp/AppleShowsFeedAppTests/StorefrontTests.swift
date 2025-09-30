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
    
    func test_displayName_returnsLocalizedName() {
        
        XCTAssertEqual(String(localized: Storefront.canada.displayName), String(localized: "storefront.canada.label"))
        XCTAssertEqual(String(localized: Storefront.spain.displayName), String(localized: "storefront.spain.label"))
    }
    
    func test_locale_returnsExpectedLocales() {
        XCTAssertEqual(Storefront.canada.locale.identifier, "en_CA")
        XCTAssertEqual(Storefront.spain.locale.identifier, "es_ES")
    }
}

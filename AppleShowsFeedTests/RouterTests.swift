//
//  RouterTests.swift
//  AppleShowsFeedTests
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import XCTest
import SwiftUI

class Router {
    var path = NavigationPath()
}

final class RouterTests: XCTestCase {
    func test_init_doesNotNavigateToDestination() {
        let sut = Router()
        
        XCTAssertEqual(sut.path, NavigationPath())
    }
}

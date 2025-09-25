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
    
    enum Destination {
        case movieDetails
    }
    
    func navigate(to destination: Destination) {
        path.append(destination)
    }
}

final class RouterTests: XCTestCase {
    func test_init_doesNotNavigateToDestination() {
        let sut = Router()
        
        XCTAssertEqual(sut.path, NavigationPath())
    }
    
    func test_navigate_navigatesToGivenDestination() {
        let sut = Router()
        
        sut.navigate(to: .movieDetails)
        
        let expectedPath: [Router.Destination] = [.movieDetails]
        XCTAssertEqual(sut.path, NavigationPath(expectedPath))
    }
}

//
//  RouterTests.swift
//  AppleShowsFeedTests
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import XCTest
import SwiftUI
import AppleShowsFeedApp

final class RouterTests: XCTestCase {
    func test_init_doesNotNavigateToDestination() {
        let sut = Router()
        
        XCTAssertEqual(sut.path, NavigationPath())
    }
    
    func test_navigate_navigatesToGivenDestination() {
        let sut = Router()
        let viewModel = MovieDetailsViewModel(
            imageURL: nil,
            name: "any name",
            category: "any category",
            releaseDate: .now,
            artist: "any artist",
            price: "any price",
            rentalPrice: "any rental price",
            summary: "any summary"
        )
        
        sut.navigate(to: .movieDetails(viewModel))
        
        let expectedPath: [Router.Destination] = [.movieDetails(viewModel)]
        XCTAssertEqual(sut.path, NavigationPath(expectedPath))
    }
    
    func test_pop_removesLastDestination() {
        let sut = Router()
        let viewModel = MovieDetailsViewModel(
            imageURL: nil,
            name: "any name",
            category: "any category",
            releaseDate: .now,
            artist: "any artist",
            price: "any price",
            rentalPrice: "any rental price",
            summary: "any summary"
        )
        
        sut.navigate(to: .movieDetails(viewModel))
        sut.pop()
        
        let expectedPath: [Router.Destination] = []
        XCTAssertEqual(sut.path, NavigationPath(expectedPath))
    }
}

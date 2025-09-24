//
//  MoviesListViewModelTests.swift
//  AppleShowsFeedAppTests
//
//  Created by Oswaldo Maestra on 24/09/2025.
//

import XCTest
import AppleShowsFeed

final class MoviesListViewModel {
    let movies: [Movie]
    
    init(movies: [Movie]) {
        self.movies = movies
    }
}

final class MoviesListViewModelTests: XCTestCase {
    func test_init_doesNotLoadMoviesOnInit() {
        let sut = MoviesListViewModel(movies: [])
        
        XCTAssertEqual(sut.movies, [])
    }
}

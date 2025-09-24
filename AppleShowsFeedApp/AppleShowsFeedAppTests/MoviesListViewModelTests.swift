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
    
    var isLoading = false
    
    init(movies: [Movie]) {
        self.movies = movies
    }
    
    func didStartLoading() {
        isLoading = true
    }
}

final class MoviesListViewModelTests: XCTestCase {
    func test_init_doesNotLoadMoviesOnInit() {
        let sut = MoviesListViewModel(movies: [])
        
        XCTAssertEqual(sut.movies, [])
    }
    
    func test_didStartLoading_setsIsLoadingToTrue() {
        let sut = MoviesListViewModel(movies: [])
        
        sut.didStartLoading()
        
        XCTAssertEqual(sut.isLoading, true)
    }
}

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
    var error: Error?
    
    init(movies: [Movie]) {
        self.movies = movies
    }
    
    func didStartLoading() {
        isLoading = true
    }
    
    func didFinishLoading(with error: Error) {
        self.error = error
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
    
    func test_didFinishLoading_deliversErrorOnLoadingError() {
        let sut = MoviesListViewModel(movies: [])
        
        sut.didFinishLoading(with: NSError(domain: "any error", code: -1))
        
        XCTAssertNotNil(sut.error)
    }
}

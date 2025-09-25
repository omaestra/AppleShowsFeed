//
//  MoviesListViewModelTests.swift
//  AppleShowsFeedAppTests
//
//  Created by Oswaldo Maestra on 24/09/2025.
//

import XCTest
import AppleShowsFeed
@testable import AppleShowsFeedApp

@MainActor
final class MoviesListViewModelTests: XCTestCase {
    func test_init_doesNotLoadMoviesOnInit() {
        let sut = MoviesListViewModel()
        
        XCTAssertEqual(sut.movies, [])
    }
    
    func test_didStartLoading_setsIsLoadingToTrue() {
        let sut = MoviesListViewModel()
        
        sut.didStartLoading()
        
        XCTAssertEqual(sut.isLoading, true)
    }
    
    func test_didFinishLoading_deliversErrorOnLoadingError() {
        let sut = MoviesListViewModel()
        
        sut.didFinishLoading(with: NSError(domain: "any error", code: -1))
        
        XCTAssertNotNil(sut.error)
    }
    
    func test_didFinishLoading_setsIsLoadingToFalse() {
        let sut = MoviesListViewModel()
        
        sut.didStartLoading()
        sut.didFinishLoading(with: NSError(domain: "any error", code: -1))
        
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_didFinishLoading_setsMoviesList() {
        let sut = MoviesListViewModel()
        
        sut.didFinishLoading(with: [])
        
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.movies, [])
    }
    
    func test_didFinishLoadingWithMovies_setsIsLoadingStateToFalse() {
        let sut = MoviesListViewModel()
        
        sut.didStartLoading()
        sut.didFinishLoading(with: [])
        
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_didFinishLoadingWithMovies_clearCurrentErrorState() {
        let sut = MoviesListViewModel()
        
        sut.didStartLoading()
        sut.didFinishLoading(with: NSError(domain: "any error", code: -1))
        
        XCTAssertNotNil(sut.error)
        
        sut.didFinishLoading(with: [])
        
        XCTAssertNil(sut.error)
    }
}

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
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.movies, [])
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_loadMovies_deliversInvalidDataErrorOnLoaderError() async {
        let expectedError = NSError(domain: "any error", code: -1)
        let (sut, _) = makeSUT(
            with: .failure(expectedError)
        )
        
        await sut.loadMovies()
        
        XCTAssertEqual(sut.error as? MoviesListViewModel.MoviesListError, .invalidData)
        XCTAssertEqual(sut.error?.localizedDescription, "We couldn’t load the movies. Please try again later.")
    }
    
    func test_loadMovies_deliversEmptyErrorOnEmptyLoaderResults() async {
        let (sut, _) = makeSUT(
            with: .success([])
        )
        
        await sut.loadMovies()
        
        XCTAssertEqual(sut.error as? MoviesListViewModel.MoviesListError, .emptyResults)
        XCTAssertEqual(sut.error?.localizedDescription, "No movies found :(")
    }
    
    func test_loadMovies_deliversMoviesOnLoaderSuccess() async {
        let expectedMovies = [makeMovie()]
        
        let (sut, _) = makeSUT(
            with: .success(expectedMovies)
        )
        
        await sut.loadMovies()
        
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.movies.map(\.id), expectedMovies.map(\.id))
    }
    
    func test_loadMovies_mapsMovieToCellViewModel() async {
        let movie = makeMovie(
            id: "123",
            name: "any movie"
        )
        
        let (sut, _) = makeSUT(with: .success([movie]))
        
        await sut.loadMovies()
        
        let cell = sut.movies.first!
        XCTAssertEqual(cell.id, "123")
        XCTAssertEqual(cell.name, "any movie")
    }
    
    func test_onSelection_callsOnSelectionWithMovie() async {
        let movie = makeMovie(id: "123", name: "any movie")
        var receivedMovie: Movie?
        
        let (sut, _) = makeSUT(with: .success([movie]), onSelection: {
            receivedMovie = $0
        })
        
        await sut.loadMovies()
        sut.movies.first?.onSelection?()
        
        XCTAssertEqual(receivedMovie?.id, "123")
        XCTAssertEqual(receivedMovie?.name, "any movie")
    }
    
    private func makeSUT(
        with result: Result<[Movie], Error> = .failure(NSError(domain: "any error", code: -1)),
        onSelection: @escaping ((Movie) -> Void) = { _ in }
    ) -> (MoviesListViewModel, MoviesLoaderStub) {
        let loader = MoviesLoaderStub(result: result)
        let sut = MoviesListViewModel(loader: loader, onSelection: onSelection)
        
        return (sut, loader)
    }
}

final class LoaderSpy: MovieLoader {
    private let loadHandler: () async throws -> [Movie]
    
    init(loadHandler: @escaping () async throws -> [Movie]) {
        self.loadHandler = loadHandler
    }
    
    func load() async throws -> [Movie] {
        try await loadHandler()
    }
}

final class MoviesLoaderStub: MovieLoader {
    private let result: Result<[Movie], Error>
        
    init(result: Result<[Movie], Error>) {
        self.result = result
    }
    
    func load() async throws -> [Movie] {
        try result.get()
    }
}

func makeMovie(
    id: String = UUID().uuidString,
    name: String = "any name"
) -> Movie {
    Movie(
        id: id,
        name: name,
        summary: "any summary",
        title: "any title",
        releaseDate: .distantPast,
        rights: "any rights",
        rentalPrice: Price(
            label: "12.99$",
            amount: 12.99,
            currency: "USD"
        ),
        price: Price(
            label: "21.99$",
            amount: 21.99,
            currency: "USD"
        ),
        artist: "any artist",
        category: "any category",
        contentType: .movie,
        duration: 12345,
        images: [
            ImageItem(
                url: URL(string: "http://some-url.com")!,
                attributes: .init(height: 60)
            )
        ]
    )
}

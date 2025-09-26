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
    
    func test_loadMovies_cancellationErrorUpdatesLoadingState() async {
        let loader = MockMovieLoader {
            try await Task.sleep(for: .seconds(1))
            throw CancellationError()
        }
        let sut = MoviesListViewModel(loader: loader, onSelection: { _ in })
        
        let refreshTask = Task {
            await sut.loadMovies()
        }
        
        // Give time to refreshTask to start
        try? await Task.sleep(for: .milliseconds(100))
        
        XCTAssertTrue(sut.isLoading, "isLoading should be true during load")
        
        sut.onSelection(makeMovie())
        
        await refreshTask.value
        
        XCTAssertEqual(sut.isLoading, false)
    }
    
    func test_loadMovies_cancellationPreventsStateUpdate() async throws {
        let mockLoader = MockMovieLoader {
            try await Task.sleep(for: .seconds(1))
            return []
        }
        let sut = MoviesListViewModel(loader: mockLoader, onSelection: { _ in })
        let expectation = XCTestExpectation(description: "Loading state")
        
        sut.onSelection = { _ in
            XCTAssertNotNil(sut.refreshTask)
            sut.cancel()
            XCTAssertNil(sut.refreshTask)
            expectation.fulfill()
        }
        
        let refreshTask = Task {
            await sut.loadMovies()
        }
        
        // Give time to refreshTask to start
        try? await Task.sleep(for: .milliseconds(100))
        
        XCTAssertTrue(sut.isLoading, "isLoading should be true during load")
        
        sut.onSelection(makeMovie())
        
        await refreshTask.value
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertFalse(sut.isLoading, "isLoading should be false after cancellation")
        XCTAssertTrue(sut.movies.isEmpty, "Movies should remain empty")
        XCTAssertNil(sut.error, "No error should be set on cancellation")
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

final class MockMovieLoader: MovieLoader {
    private let loader: () async throws -> [Movie]
    
    init(loader: @escaping () async throws -> [Movie]) {
        self.loader = loader
    }
    
    func load() async throws -> [Movie] {
        try await loader()
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
        images: [
            ImageItem(
                url: URL(string: "http://some-url.com")!,
                attributes: .init(height: 60)
            )
        ]
    )
}

//
//  MoviesListViewModel.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 24/09/2025.
//

import Foundation
import AppleShowsFeed

final class MoviesListViewModel: ObservableObject {
    @Published private(set) var movies: [MovieCellViewModel] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let loader: MovieLoader
    private var onSelection: (Movie) -> Void
    
    enum MoviesListError: LocalizedError, Equatable {
        case invalidData
        case emptyResults

        var errorDescription: String? {
            switch self {
            case .invalidData:
                return "We couldn’t load the movies. Please try again later."
            case .emptyResults:
                return "No movies found :("
            }
        }
    }
    
    init(
        loader: MovieLoader,
        onSelection: @escaping (Movie) -> Void
    ) {
        self.loader = loader
        self.onSelection = onSelection
    }
    
    func loadMovies() async {
        do {
            await didStartLoading()
            
            let movies = try await loader.load()
            if movies.isEmpty {
                throw MoviesListError.emptyResults
            }
            
            let cellViewModels = mapMoviesToCellViewModels(movies: movies)
            await didFinishLoading(with: cellViewModels)
        } catch let error as MoviesListError {
            await didFinishLoading(with: error)
        } catch {
            await didFinishLoading(with: MoviesListError.invalidData)
        }
    }
    
    private func mapMoviesToCellViewModels(movies: [Movie]) -> [MovieCellViewModel] {
        return movies.map { movie in
            let viewModel = MovieCellViewModel(
                id: movie.id,
                imageURL: movie.images.last?.url,
                name: movie.name,
                category: movie.category,
                rentalPrice: movie.rentalPrice?.label,
                price: movie.price.label
            )
            
            viewModel.onSelection = { [onSelection] in
                onSelection(movie)
            }
            
            return viewModel
        }
    }
    
    @MainActor
    private func didStartLoading() {
        isLoading = true
    }
    
    @MainActor
    private func didFinishLoading(with error: Error) {
        self.error = error
        self.isLoading = false
    }
    
    @MainActor
    private func didFinishLoading(with movies: [MovieCellViewModel]) {
        self.movies = movies
        self.isLoading = false
        self.error = nil
    }
}

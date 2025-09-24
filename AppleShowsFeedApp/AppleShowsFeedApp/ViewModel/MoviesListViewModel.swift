//
//  MoviesListViewModel.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 24/09/2025.
//

import Foundation
import AppleShowsFeed

@MainActor
final class MoviesListViewModel: ObservableObject {
    @Published private(set) var movies: [Movie]
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    init(movies: [Movie]) {
        self.movies = movies
    }
    
    func didStartLoading() {
        isLoading = true
    }
    
    func didFinishLoading(with error: Error) {
        self.error = error
        self.isLoading = false
    }
    
    func didFinishLoading(with movies: [Movie]) {
        self.movies = movies
        self.isLoading = false
    }
}

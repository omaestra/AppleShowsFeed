//
//  MoviesListViewModel.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 24/09/2025.
//

import Foundation
import AppleShowsFeed

final class MoviesListViewModel: ObservableObject {
    @Published private(set) var movies: [Movie]
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    public var onRefresh: (() async -> Void)?
    
    init(movies: [Movie]) {
        self.movies = movies
    }
    
    @MainActor
    func didStartLoading() {
        isLoading = true
    }
    
    @MainActor
    func didFinishLoading(with error: Error) {
        self.error = error
        self.isLoading = false
    }
    
    @MainActor
    func didFinishLoading(with movies: [Movie]) {
        self.movies = movies
        self.isLoading = false
        self.error = nil
    }
}

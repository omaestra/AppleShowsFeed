//
//  MoviesListViewModel.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 24/09/2025.
//

import Foundation
import AppleShowsFeed

final class MoviesListViewModel {
    var movies: [Movie]
    
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
        self.isLoading = false
    }
    
    func didFinishLoading(with movies: [Movie]) {
        self.movies = movies
        self.isLoading = false
    }
}

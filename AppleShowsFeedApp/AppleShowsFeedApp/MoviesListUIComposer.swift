//
//  MoviesListUIComposer.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import SwiftUI
import AppleShowsFeed

final class MoviesListUIComposer {
    static func composedWith(
        loader: MovieLoader,
        onSelection: @escaping (Movie) -> Void
    ) -> some View {
        let viewModel = MoviesListViewModel(loader: loader, onSelection: onSelection)
        
        return MoviesListView(viewModel: viewModel)
            .task {
                await viewModel.loadMovies()
            }
            .refreshable {
                await viewModel.loadMovies()
            }
    }
}

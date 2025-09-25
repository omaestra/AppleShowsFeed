//
//  MoviesUIListView.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import SwiftUI
import AppleShowsFeed

final class MoviesUIListView {
    static func composedWith(
        loader: MovieLoader
    ) -> some View {
        let viewModel = MoviesListViewModel(movies: [])
        viewModel.onRefresh = { [loader, weak viewModel] in
            do {
                await viewModel?.didStartLoading()
                let movies = try await loader.load()
                await viewModel?.didFinishLoading(with: movies)
            } catch {
                await viewModel?.didFinishLoading(with: error)
            }
        }
        
        return MoviesListView(viewModel: viewModel)
            .task {
                await viewModel.onRefresh?()
            }
            .refreshable {
                await viewModel.onRefresh?()
            }
    }
}

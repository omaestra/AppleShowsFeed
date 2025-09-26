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
        let viewModel = MoviesListViewModel()
        viewModel.onRefresh = { [loader, weak viewModel] in
            do {
                await viewModel?.didStartLoading()
                let movies = try await loader.load()
                
                let cellViewModels = movies.map { movie in
                    
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
                
                await viewModel?.didFinishLoading(with: cellViewModels)
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

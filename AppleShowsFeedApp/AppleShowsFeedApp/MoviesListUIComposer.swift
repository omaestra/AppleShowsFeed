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
        onSelection: @escaping () -> Void
    ) -> some View {
        let viewModel = MoviesListViewModel()
        viewModel.onRefresh = { [loader, weak viewModel] in
            do {
                await viewModel?.didStartLoading()
                let movies = try await loader.load()
                
                let cellViewModels = movies.map {
                    
                    let viewModel = MovieCellViewModel(
                        id: $0.id,
                        imageURL: $0.images.last?.url,
                        name: $0.name,
                        category: $0.category,
                        rentalPrice: $0.rentalPrice?.label,
                        price: $0.price.label
                    )
                    
                    viewModel.onSelection = onSelection
                    
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

//
//  AppleShowsFeedApp.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 24/09/2025.
//

import SwiftUI
import AppleShowsFeed

@main
struct AppleShowsFeedApp: App {
    /// Hardcoded country value to simply display different feeds by country.
    @State private var selectedStore: Storefront = .canada
    @State private var router = Router()
    
    private let appComposer = AppComposer()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                MoviesListUIComposer.composedWith(
                    loader: appComposer.makeMoviesLoader(for: .canada),
                    onSelection: { movie in
                        let viewModel = MovieDetailsViewModel(
                            imageURL: movie.images.last?.url,
                            name: movie.name,
                            category: movie.category,
                            releaseDate: movie.releaseDate,
                            artist: movie.artist,
                            price: movie.price.label,
                            rentalPrice: movie.rentalPrice?.label,
                            summary: movie.summary
                        )
                        
                        router.navigate(to: .movieDetails(viewModel))
                    }
                )
                .id(selectedStore.id)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        LanguagePicker(selectedStore: $selectedStore)
                    }
                }
                .navigationDestination(for: Router.Destination.self) { destination in
                    switch destination {
                    case let .movieDetails(viewModel):
                        MovieDetailsView(viewModel: viewModel)
                    }
                }
            }
            .environment(\.locale, selectedStore.locale)
        }
    }
}

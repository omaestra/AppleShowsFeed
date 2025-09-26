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
    @State private var selectedCountry: Country = .canada
    @State private var id: UUID = UUID()
    
    private static let httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession.shared)
    }()
    
    private func makeLoader(for countryCode: String) -> MovieLoader {
        let url = URL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topMovies/limit=100/json?cc=\(countryCode)")!
        return RemoteMovieLoader(url: url, client: Self.httpClient, mapper: MoviesMapper.map)
    }
    
    @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                MoviesListUIComposer.composedWith(
                    loader: makeLoader(for: selectedCountry.id),
                    onSelection: { [weak router] movie in
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
                        router?.navigate(to: .movieDetails(viewModel))
                    }
                )
                .id(id)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        LanguagePicker(selectedCountry: $selectedCountry)
                    }
                }
                .onChange(of: selectedCountry, { oldValue, newValue in
                    id = UUID()
                })
                .navigationDestination(for: Router.Destination.self) { destination in
                    switch destination {
                    case let .movieDetails(viewModel):
                        MovieDetailsView(viewModel: viewModel)
                    }
                }
            }
        }
    }
}

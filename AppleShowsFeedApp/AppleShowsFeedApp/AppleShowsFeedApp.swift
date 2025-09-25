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
    private static let httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession.shared)
    }()
    
    private static let remoteMovieLoader: RemoteMovieLoader = {
        let url = URL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topMovies/limit=2/json?cc=ca")!
        return RemoteMovieLoader(url: url, client: httpClient, mapper: MoviesMapper.map)
    }()
    
    var body: some Scene {
        WindowGroup {
            MoviesUIListView.composedWith(loader: Self.remoteMovieLoader)
        }
    }
}

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

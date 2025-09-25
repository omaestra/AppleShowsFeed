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
    
    @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                MoviesListUIComposer.composedWith(
                    loader: Self.remoteMovieLoader,
                    onSelection: { [weak router] in
                        router?.navigate(to: .movieDetails)
                    }
                )
                .navigationDestination(for: Router.Destination.self) { destination in
                    switch destination {
                    case .movieDetails:
                        Text("Movie Details View")
                    }
                }
            }
        }
    }
}

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
            MoviesListUIComposer.composedWith(loader: Self.remoteMovieLoader)
        }
    }
}

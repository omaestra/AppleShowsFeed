//
//  AppComposer.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 30/09/2025.
//

import Foundation
import AppleShowsFeed

final class AppComposer {
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession.shared)
    }()
    
    private lazy var baseURL = URL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS")!
    
    func makeMoviesLoader(for storeFront: Storefront = .canada) -> MovieLoader {
        /// Apple provides JSON RSS feed structure, better for reducing boilerplate and integration with Swift's `Decodable` protocol.
        let url = baseURL
            .appending(path: "/topMovies/json")
            .appending(queryItems: [
            URLQueryItem(name: "cc", value: storeFront.id)
        ])
        
        return RemoteMovieLoader(url: url, client: httpClient, mapper: MoviesMapper.map)
    }
    
    convenience init(httpClient: HTTPClient) {
        self.init()
        self.httpClient = httpClient
    }
}

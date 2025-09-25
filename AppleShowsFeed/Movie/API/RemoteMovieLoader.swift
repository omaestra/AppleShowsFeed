//
//  RemoteMovieLoader.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import Foundation

public class RemoteMovieLoader: MovieLoader {
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public let url: URL
    public let client: HTTPClient
    public let mapper: (Data, HTTPURLResponse) throws -> [Movie]
    
    public init(
        url: URL,
        client: HTTPClient,
        mapper: @escaping (Data, HTTPURLResponse) throws -> [Movie]
    ) {
        self.url = url
        self.client = client
        self.mapper = mapper
    }
    
    public func load() async throws -> [Movie] {
        let result = await client.get(from: url)
        
        switch result {
        case let .success((data, response)):
            do {
                return try mapper(data, response)
            } catch {
                throw Error.invalidData
            }
            
        case .failure:
            throw Error.connectivity
        }
    }
}

//
//  RemoteMovieLoader.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import Foundation

public class RemoteMovieLoader {
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public let url: URL
    public let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() async throws -> [Movie] {
        let result = await client.get(from: url)
        
        switch result {
        case let .success((data, response)):
            guard response.statusCode == 200 else {
                throw Error.invalidData
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                let movies = try jsonDecoder.decode(Root<[Movie]>.self, from: data)
                return movies.items
            } catch {
                throw Error.invalidData
            }
            
        case .failure:
            throw Error.connectivity
        }
    }
}

private struct Root<Resource>: Decodable where Resource: Decodable {
    let items: Resource
    
    private enum CodingKeys: String, CodingKey {
        case items = "entry"
    }
}

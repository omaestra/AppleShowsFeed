//
//  MoviesMapper.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import Foundation

public class MoviesMapper {
    public static func map(_ data: Data, response: HTTPURLResponse) throws -> [Movie] {
        guard response.statusCode == 200 else {
            throw RemoteMovieLoader.Error.invalidData
        }
        
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            let movies = try jsonDecoder.decode(Root<[Movie]>.self, from: data)
            return movies.items
        } catch {
            throw RemoteMovieLoader.Error.invalidData
        }
    }
}

private struct Root<Resource>: Decodable where Resource: Decodable {
    let items: Resource
    
    private enum CodingKeys: String, CodingKey {
        case items = "entry"
    }
}

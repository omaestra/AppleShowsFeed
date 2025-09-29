//
//  MoviesMapper.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import Foundation

/// **DECISION RECORD**: JSON chosen over XML for iTunes API integration
/// - iTunes API supports JSON by default (no format negotiation needed).
/// - JSONDecoder provides compile-time type safety vs runtime XML parsing.
/// - Abstracted behind `MovieMapper` protocol for format swap capability
public class MoviesMapper {
    public static func map(_ data: Data, response: HTTPURLResponse) throws -> [Movie] {
        guard response.statusCode == 200 else {
            throw RemoteMovieLoader.Error.invalidData
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let movies = try decoder.decode(Root<[Movie]>.self, from: data)
            return movies.items
        } catch {
            throw RemoteMovieLoader.Error.invalidData
        }
    }
}

private struct Root<Resource>: Decodable where Resource: Decodable {
    let items: Resource
    
    private enum CodingKeys: String, CodingKey {
        case feed
    }
    
    private enum EntryCodingKeys: String, CodingKey {
        case items = "entry"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let entriesContainer = try container.nestedContainer(keyedBy: EntryCodingKeys.self, forKey: .feed)
        self.items = try entriesContainer.decode(Resource.self, forKey: EntryCodingKeys.items)
    }
}

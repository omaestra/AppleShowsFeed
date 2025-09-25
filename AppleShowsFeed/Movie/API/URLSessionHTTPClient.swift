//
//  URLSessionHTTPClient.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    public enum Error: Swift.Error {
        case invalidHTTPResponse
    }
    
    public let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func get(from url: URL) async -> HTTPClient.Result {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw Error.invalidHTTPResponse }
            return .success((data, httpResponse))
        } catch {
            return .failure(error)
        }
    }
}

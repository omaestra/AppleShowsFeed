//
//  URLSessionHTTPClient.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    enum Error: Swift.Error {
        case invalidHTTPResponse
    }
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) async -> HTTPClient.Result {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw Error.invalidHTTPResponse }
            return .success((data, httpResponse))
        } catch {
            return .failure(error)
        }
    }
}

//
//  RemoteMovieLoaderTests.swift
//  AppleShowsFeedTests
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import XCTest
import AppleShowsFeed

class HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        self.requestedURL = url
    }
}

class RemoteMovieLoader {
    var client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() async throws -> [Movie] {
        client.get(from: URL(string: "https://some-url.com")!)
        return []
    }
}

final class RemoteMovieLoaderTests: XCTestCase {
    func test_load_requestsDataFromURL() async {
        let client = HTTPClient()
        let sut = RemoteMovieLoader(client: client)
        
        _ = try? await sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}

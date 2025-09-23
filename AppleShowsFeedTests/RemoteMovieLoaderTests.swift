//
//  RemoteMovieLoaderTests.swift
//  AppleShowsFeedTests
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import XCTest
import AppleShowsFeed

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        self.requestedURL = url
    }
}

class RemoteMovieLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() async throws -> [Movie] {
        client.get(from: url)
        return []
    }
}

final class RemoteMovieLoaderTests: XCTestCase {
    func test_load_requestsDataFromURL() async {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteMovieLoader(url: url, client: client)
        
        _ = try? await sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}

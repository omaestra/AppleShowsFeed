//
//  RemoteMovieLoaderTests.swift
//  AppleShowsFeedTests
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import XCTest
import AppleShowsFeed

protocol HTTPClient {
    func get(from url: URL) throws
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    var error: Error?
    
    func get(from url: URL) throws {
        if let error { throw error }
        self.requestedURL = url
    }
}

class RemoteMovieLoader {
    public enum Error: Swift.Error {
        case connectivity
    }
    
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() async throws -> [Movie] {
        do {
            try client.get(from: url)
        } catch {
            throw Error.connectivity
        }
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
    
    func test_load_deliversErrorOnClientError() async {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        client.error = NSError(domain: "any error", code: -1)
        let sut = RemoteMovieLoader(url: url, client: client)
        
        do {
            _ = try await sut.load()
            XCTFail("Expected failure, got success instead")
        } catch {
            XCTAssertEqual(error as? RemoteMovieLoader.Error, .connectivity)
        }
    }
}

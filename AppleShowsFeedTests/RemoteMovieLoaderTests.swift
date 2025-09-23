//
//  RemoteMovieLoaderTests.swift
//  AppleShowsFeedTests
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import XCTest
import AppleShowsFeed

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL) async -> Result
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    var error: Error?
    var result: Result<(Data, HTTPURLResponse), Error>?
    
    func get(from url: URL) async -> HTTPClient.Result {
        self.requestedURL = url
        return result ?? .failure(NSError(domain: "any error", code: -1))
    }
    
    func didComplete(with result: HTTPClient.Result) {
        self.result = result
    }
    
    func didComplete(with error: Error) {
        self.result = .failure(error)
    }
}

class RemoteMovieLoader {
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() async throws -> [Movie] {
        do {
            let result = await client.get(from: url)
            
            switch result {
            case let .success((_, response)):
                guard response.statusCode == 200 else {
                    throw Error.invalidData
                }
                
                return []
                
            case .failure:
                throw Error.connectivity
            }
        } catch {
            throw error
        }
    }
}

final class RemoteMovieLoaderTests: XCTestCase {
    func test_load_requestsDataFromURL() async {
        let (sut, client) = makeSUT()
        
        _ = try? await sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
    
    func test_load_deliversErrorOnClientError() async {
        let (sut, client) = makeSUT()
        
        client.didComplete(with: NSError(domain: "any error", code: -1))
        
        do {
            _ = try await sut.load()
            XCTFail("Expected failure, got success instead")
        } catch {
            XCTAssertEqual(error as? RemoteMovieLoader.Error, .connectivity)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() async {
        let url = URL(string: "http://any-url.com")!
        let (sut, client) = makeSUT()
        
        let httpResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
        let data = Data()
        
        client.didComplete(with: .success((data, httpResponse)))
        
        do {
            _ = try await sut.load()
        } catch {
            XCTAssertEqual(error as? RemoteMovieLoader.Error, .invalidData)
        }
    }
    
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!,
        with result: HTTPClient.Result = .failure(NSError(domain: "any error", code: -1)),
    ) -> (RemoteMovieLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteMovieLoader(url: url, client: client)
        
        return (sut, client)
    }
}

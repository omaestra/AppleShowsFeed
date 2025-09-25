//
//  RemoteMovieLoaderTests.swift
//  AppleShowsFeedTests
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import XCTest
import AppleShowsFeed

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
    
    func test_load_deliversErrorOnMapperError() async {
        let url = URL(string: "http://any-url.com")!
        let httpResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
        let data = Data()
        
        let (sut, client) = makeSUT(mapper: { _, _ in
            throw NSError(domain: "any error", code: -1)
        })
        
        client.didComplete(with: .success((data, httpResponse)))
        
        do {
            _ = try await sut.load()
        } catch {
            XCTAssertEqual(error as? RemoteMovieLoader.Error, .invalidData)
        }
    }
    
    func test_load_deliversMappedResource() async {
        let url = URL(string: "http://any-url.com")!
        let movie1 = makeMovie(
            summary: "any summary",
            rights: "any rights",
            rentalPrice: Price(label: "12.99$", amount: 12.99, currency: "USD")
        )
        let movie2 = makeMovie()
        
        let (sut, client) = makeSUT(url: url) { _, _ in
            return [movie1, movie2]
        }
        
        let valid200Response = (Data(), HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        client.didComplete(with: .success(valid200Response))
        
        do {
            let result = try await sut.load()
            XCTAssertEqual(result, [movie1, movie2])
        } catch {
            XCTFail("Expected empty result, got \(error) instead")
        }
    }
    
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!,
        with result: HTTPClient.Result = .failure(NSError(domain: "any error", code: -1)),
        mapper: @escaping (Data, HTTPURLResponse) throws -> [Movie] = MoviesMapper.map
    ) -> (RemoteMovieLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteMovieLoader(url: url, client: client, mapper: mapper)
        
        return (sut, client)
    }
}

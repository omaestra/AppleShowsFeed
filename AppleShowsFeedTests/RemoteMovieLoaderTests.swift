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
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() async {
        let url = URL(string: "http://any-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        let invalidJSON = Data("invalid json".utf8)
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        client.didComplete(with: .success((invalidJSON, httpResponse)))
        
        do {
            _ = try await sut.load()
            XCTFail("Expected invalid JSON error.")
        } catch {
            XCTAssertEqual(error as? RemoteMovieLoader.Error, .invalidData)
        }
    }
    
    func test_load_deliversEmptyOn200HTTPResponseWithEmptyJSONList() async {
        let url = URL(string: "http://any-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        let emptyListJSON = Data("{\"entry\": []}".utf8)
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        client.didComplete(with: .success((emptyListJSON, httpResponse)))
        
        do {
            let result = try await sut.load()
            XCTAssertEqual(result, [])
        } catch {
            XCTFail("Expected empty result, got \(error) instead")
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() async {
        let url = URL(string: "http://any-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        let movie1 = makeMovie()
        let movie1JSON = makeJSON(from: movie1)
        let movie2 = makeMovie()
        let movie2JSON = makeJSON(from: movie2)
        
        let itemsJSON = [
            "entry": [movie1JSON, movie2JSON]
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: itemsJSON)
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        client.didComplete(with: .success((jsonData, httpResponse)))
        
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
    ) -> (RemoteMovieLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteMovieLoader(url: url, client: client)
        
        return (sut, client)
    }
}

func makeMovie(id: UUID = UUID()) -> Movie {
    Movie(
        id: id.uuidString,
        name: "any name",
        summary: "any summary",
        title: "any title",
        releaseDate: .distantPast,
        rights: "any rights",
        rentalPrice: Price(
            label: "12.99$",
            amount: 12.99,
            currency: "USD"
        ),
        price: Price(
            label: "21.99$",
            amount: 21.99,
            currency: "USD"
        ),
        artist: "any artist",
        category: "any category",
        contentType: .movie,
        duration: 12345,
        images: [
            ImageItem(
                url: URL(string: "http://some-url.com")!,
                attributes: .init(height: 60)
            )
        ]
    )
}

func makeJSON(from movie: Movie) -> [String: Any] {
    return [
        "id": movie.id,
        "name": movie.name,
        "summary": movie.summary,
        "title": movie.title,
        "releaseDate": movie.releaseDate.ISO8601Format(),
        "rights": movie.rights,
        "rentalPrice": [
            "label": movie.rentalPrice.label,
            "amount": movie.rentalPrice.amount,
            "currency": movie.rentalPrice.currency
        ],
        "price": [
            "label": movie.price.label,
            "amount": movie.price.amount,
            "currency": movie.price.currency
        ],
        "artist": movie.artist,
        "category": movie.category,
        "contentType": movie.contentType.rawValue,
        "duration": movie.duration,
        "images": movie.images.map {
            [
                "url": $0.url.absoluteString,
                "attributes": [
                    "height": $0.attributes.height
                ]
            ]
        }
    ]
}

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
        
        let emptyListJSON = Data("{\"feed\": { \"entry\": [] }}".utf8)
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
            "feed": ["entry": [movie1JSON, movie2JSON]]
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
        let sut = RemoteMovieLoader(url: url, client: client, mapper: MoviesMapper.map)
        
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
        "id": [
            "label": movie.id,
            "attributes": [
                "im:id": movie.id
            ]
        ],
        "im:name": ["label": movie.name],
        "summary": ["label": movie.summary],
        "title": ["label": movie.title],
        "im:releaseDate": [
            "label": movie.releaseDate.ISO8601Format(),
            "attributes": ["label": "July 25, 2025"]
        ],
        "rights": ["label": movie.rights],
        "im:rentalPrice": [
            "label": movie.rentalPrice?.label ?? "12.99$",
            "attributes": [
                "amount": String(movie.rentalPrice?.amount ?? 0.0),
                "currency": movie.rentalPrice?.currency
            ]
        ],
        "im:price": [
            "label": movie.price.label,
            "attributes": [
                "amount": String(movie.price.amount),
                "currency": movie.price.currency
            ]
        ],
        "im:artist": [
            "label": movie.artist
        ],
        "category": [
            "attributes": [
                "im:id": "4401",
                "term": "Action & Adventure",
                "label": movie.category
            ]
        ],
        "im:contentType": [
            "attributes": [
                "label": movie.contentType.rawValue,
                "term": movie.contentType.rawValue
            ]
        ],
        "im:image": movie.images.map {
            [
                "label": $0.url.absoluteString,
                "attributes": [
                    "height": String($0.attributes.height ?? 0)
                ]
            ]
        }
    ]
}

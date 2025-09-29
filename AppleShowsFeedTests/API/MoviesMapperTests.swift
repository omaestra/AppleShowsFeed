//
//  MoviesMapperTests.swift
//  AppleShowsFeedTests
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import XCTest
import AppleShowsFeed

final class MoviesMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let itemsJSON = [
            "feed": ["entry": []]
        ]
        let jsonData = try JSONSerialization.data(withJSONObject: itemsJSON)
        
        let statusCodeSamples = [199, 201, 300, 400, 500]
        
        try statusCodeSamples.forEach { code in
            XCTAssertThrowsError(
                try MoviesMapper.map(jsonData, response: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try MoviesMapper.map(invalidJSON, response: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let itemsJSON = [
            "feed": ["entry": []]
        ]
        let jsonData = try JSONSerialization.data(withJSONObject: itemsJSON)
        
        let result = try MoviesMapper.map(jsonData, response: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let movie1 = makeMovie(
            summary: "any summary",
            rights: "any rights",
            rentalPrice: Price(label: "12.99$", amount: 12.99, currency: "USD")
        )
        let movie1JSON = makeJSON(from: movie1)
        let movie2 = makeMovie()
        let movie2JSON = makeJSON(from: movie2)
        
        let itemsJSON = [
            "feed": ["entry": [movie1JSON, movie2JSON]]
        ]
        let jsonData = try JSONSerialization.data(withJSONObject: itemsJSON)
        let httpResponse = HTTPURLResponse(statusCode: 200)
        
        let result = try MoviesMapper.map(jsonData, response: httpResponse)
        
        XCTAssertEqual(result, [movie1, movie2])
    }
}

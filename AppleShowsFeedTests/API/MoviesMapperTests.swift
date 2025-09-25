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
        let url = URL(string: "http://any-url.com")!
        let itemsJSON = [
            "feed": ["entry": []]
        ]
        let jsonData = try JSONSerialization.data(withJSONObject: itemsJSON)
        
        let statusCodeSamples = [199, 201, 300, 400, 500]
        
        try statusCodeSamples.forEach { code in
            XCTAssertThrowsError(
                try MoviesMapper.map(jsonData, response: HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!)
            )
        }
    }
}

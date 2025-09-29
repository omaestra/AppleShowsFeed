//
//  MoviesAPIEndToEndTests.swift
//  MoviesAPIEndToEndTests
//
//  Created by Oswaldo Maestra on 29/09/2025.
//

import XCTest
import AppleShowsFeed

final class MoviesAPIEndToEndTests: XCTestCase {
    func test_endToEndTestServerGETMoviesResult_mapsCorrectlyWithDomainModelStructure() async {
        let url = URL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topMovies/limit=2/json?cc=ca")!
        let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        
        let result = await httpClient.get(from: url)
        let mappedResult = result.flatMap { (data, response) in
            do {
                return .success(try MoviesMapper.map(data, response: response))
            } catch {
                return .failure(error)
            }
        }
        
        switch mappedResult {
        case let .success(movies):
            XCTAssertEqual(movies.count, 2)
            
        case let .failure(error):
            XCTFail("Expected successful movies feed result, got \(error) instead")
        }
    }
}

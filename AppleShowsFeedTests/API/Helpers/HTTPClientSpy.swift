//
//  HTTPClientSpy.swift
//  AppleShowsFeedTests
//
//  Created by Oswaldo Maestra on 24/09/2025.
//

import Foundation
import AppleShowsFeed

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

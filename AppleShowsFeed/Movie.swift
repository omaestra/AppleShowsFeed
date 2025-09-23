//
//  Movie.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import Foundation

public enum FeedContentType {
    case movie
}

public struct ImageAttributes {
    public let height: Int
}

public struct ImageItem {
    public let url: URL
    public let attributes: ImageAttributes
}

public struct Price {
    public let label: String
    public let amount: Double
    public let currency: String
}

public struct Movie {
    public let id: String
    public let name: String
    public let summary: String
    public let title: String
    public let releaseDate: Date
    public let rights: String
    public let rentalPrice: Price
    public let price: Price
    public let artist: String
    public let category: String
    public let contentType: FeedContentType
    public let duration: Double
    public let images: [ImageItem]
}

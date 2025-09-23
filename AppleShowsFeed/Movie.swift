//
//  Movie.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import Foundation

enum FeedContentType {
    case movie
}

struct ImageAttributes {
    let height: Int
}

struct ImageItem {
    let url: URL
    let attributes: ImageAttributes
}

struct Price {
    let label: String
    let amount: Double
    let currency: String
}

struct Movie {
    let id: String
    let name: String
    let summary: String
    let title: String
    let releaseDate: Date
    let rights: String
    let rentalPrice: Price
    let price: Price
    let artist: String
    let category: String
    let contentType: FeedContentType
    let duration: Double
    let images: [ImageItem]
}

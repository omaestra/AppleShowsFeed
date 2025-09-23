//
//  Movie.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import Foundation

public enum FeedContentType: String {
    case movie
}

public struct ImageAttributes: Equatable {
    public let height: Int
    
    public init(height: Int) {
        self.height = height
    }
}

public struct ImageItem: Equatable {
    public let url: URL
    public let attributes: ImageAttributes
    
    public init(
        url: URL,
        attributes: ImageAttributes
    ) {
        self.url = url
        self.attributes = attributes
    }
}

public struct Price: Equatable {
    public let label: String
    public let amount: Double
    public let currency: String
    
    public init(
        label: String,
        amount: Double,
        currency: String
    ) {
        self.label = label
        self.amount = amount
        self.currency = currency
    }
}

public struct Movie: Equatable {
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
    
    public init(
        id: String,
        name: String,
        summary: String,
        title: String,
        releaseDate: Date,
        rights: String,
        rentalPrice: Price,
        price: Price,
        artist: String,
        category: String,
        contentType: FeedContentType,
        duration: Double,
        images: [ImageItem]
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.title = title
        self.releaseDate = releaseDate
        self.rights = rights
        self.rentalPrice = rentalPrice
        self.price = price
        self.artist = artist
        self.category = category
        self.contentType = contentType
        self.duration = duration
        self.images = images
    }
}

extension Movie: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case summary
        case title
        case releaseDate
        case rights
        case rentalPrice
        case price
        case artist
        case category
        case contentType
        case duration
        case images
        
    }
}

extension ImageAttributes: Decodable {
    private enum CodingKeys: String, CodingKey {
        case height
    }
}

extension ImageItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case attributes
        case url
    }
}

extension Price: Decodable {
    private enum CodingKeys: String, CodingKey {
        case label
        case amount
        case currency
    }
}

extension FeedContentType: Decodable {}

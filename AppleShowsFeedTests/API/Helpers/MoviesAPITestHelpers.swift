//
//  MoviesAPITestHelpers.swift
//  AppleShowsFeedTests
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import Foundation
import AppleShowsFeed

func makeMovie(
    id: UUID = UUID(),
    summary: String? = nil,
    rights: String? = nil,
    rentalPrice: Price? = nil
) -> Movie {
    Movie(
        id: id.uuidString,
        name: "any name",
        summary: summary,
        title: "any title",
        releaseDate: .distantPast,
        rights: rights,
        rentalPrice: rentalPrice,
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
    var json: [String: Any] = [
        "id": [
            "label": movie.id,
            "attributes": [
                "im:id": movie.id
            ]
        ],
        "im:name": ["label": movie.name],
        "title": ["label": movie.title],
        "im:releaseDate": [
            "label": movie.releaseDate.ISO8601Format(),
            "attributes": ["label": "July 25, 2025"]
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
    
    if let summary = movie.summary {
        json["summary"] = ["label": summary]
    }
    if let rights = movie.rights {
        json["rights"] = ["label": rights]
    }
    if let rentalPrice = movie.rentalPrice {
        json["im:rentalPrice"] = [
            "label": rentalPrice.label,
            "attributes": [
                "amount": String(rentalPrice.amount),
                "currency": rentalPrice.currency
            ]
        ]
    }
    
    return json
}

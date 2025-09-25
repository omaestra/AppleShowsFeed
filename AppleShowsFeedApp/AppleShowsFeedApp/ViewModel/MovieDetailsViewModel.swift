//
//  MovieDetailsViewModel.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import Foundation

public struct MovieDetailsViewModel: Hashable {
    public let imageURL: URL?
    public let name: String
    public let category: String
    public let releaseDate: Date
    public let artist: String?
    public let price: String
    public let rentalPrice: String?
    public let summary: String?
    
    public init(
        imageURL: URL?, 
        name: String, 
        category: String, 
        releaseDate: Date, 
        artist: String?, 
        price: String, 
        rentalPrice: String?, summary: String?
    ) {
        self.imageURL = imageURL
        self.name = name
        self.category = category
        self.releaseDate = releaseDate
        self.artist = artist
        self.price = price
        self.rentalPrice = rentalPrice
        self.summary = summary
    }
}

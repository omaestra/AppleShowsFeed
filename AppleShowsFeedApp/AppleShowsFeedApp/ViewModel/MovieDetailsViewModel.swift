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
}

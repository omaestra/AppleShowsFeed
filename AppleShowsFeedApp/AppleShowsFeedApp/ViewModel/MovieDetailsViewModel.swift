//
//  MovieDetailsViewModel.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import Foundation

struct MovieDetailsViewModel {
    let imageURL: URL?
    let name: String
    let category: String
    let releaseDate: Date
    let artist: String?
    let price: String
    let rentalPrice: String?
    let summary: String?
}

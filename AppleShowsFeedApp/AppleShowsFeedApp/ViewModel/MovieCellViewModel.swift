//
//  MovieCellViewModel.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import Foundation

final class MovieCellViewModel: Equatable {
    static func == (lhs: MovieCellViewModel, rhs: MovieCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    public var onSelection: (() -> Void)?
    
    let id: String
    let imageURL: URL?
    let name: String
    let category: String
    let rentalPrice: String?
    let price: String
    
    init(
        id: String,
        imageURL: URL?,
        name: String,
        category: String,
        rentalPrice: String?,
        price: String
    ) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.category = category
        self.rentalPrice = rentalPrice
        self.price = price
    }
}

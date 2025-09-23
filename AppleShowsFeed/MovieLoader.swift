//
//  MovieLoader.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import Foundation

protocol MovieLoader {
    func load() async throws -> [Movie]
}

//
//  MovieLoader.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 23/09/2025.
//

import Foundation

public protocol MovieLoader {
    func load() async throws -> [Movie]
}

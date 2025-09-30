//
//  Storefront.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 26/09/2025.
//

import Foundation

/// Hardcoded country values only for simply display different feeds by country.
enum Storefront: String, CaseIterable, Identifiable {
    case canada = "ca"
    case spain = "es"
    
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .canada: return "🇨🇦 Canada"
        case .spain: return "🇪🇸 Spain"
        }
    }
}

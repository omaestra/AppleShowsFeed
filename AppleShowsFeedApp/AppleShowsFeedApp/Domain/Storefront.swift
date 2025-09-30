//
//  Storefront.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 26/09/2025.
//

import Foundation

/// Hardcoded country values only for simply display different feeds by country.
public enum Storefront: String, CaseIterable, Identifiable {
    case canada = "ca"
    case spain = "es"
    
    public var id: String { rawValue }
    public var displayName: LocalizedStringResource {
        switch self {
        case .canada: return LocalizedStringResource(stringLiteral: "storefront.canada.label")
        case .spain: return LocalizedStringResource(stringLiteral: "storefront.spain.label")
        }
    }
    
    public var locale: Locale {
        switch self {
        case .canada: Locale(identifier: "en_CA")
        case .spain: Locale(identifier: "es_ES")
        }
    }
}

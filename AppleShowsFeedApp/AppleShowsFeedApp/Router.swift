//
//  Router.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import Foundation
import SwiftUI

public struct Router {
    public var path = NavigationPath()
    
    public enum Destination: Hashable {
        case movieDetails(MovieDetailsViewModel)
    }
    
    public init() {}
    
    public mutating func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    public mutating func pop() {
        path.removeLast()
    }
}

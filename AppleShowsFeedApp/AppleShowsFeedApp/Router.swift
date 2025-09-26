//
//  Router.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import Foundation
import SwiftUI

public final class Router: ObservableObject {
    @Published public var path = NavigationPath()
    
    public enum Destination: Hashable {
        case movieDetails(MovieDetailsViewModel)
    }
    
    public init() {}
    
    public func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    public func pop() {
        path.removeLast()
    }
}

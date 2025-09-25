//
//  Router.swift
//  AppleShowsFeed
//
//  Created by Oswaldo Maestra on 25/09/2025.
//

import SwiftUI

public final class Router {
    public var path = NavigationPath()
    
    public enum Destination {
        case movieDetails
    }
    
    public init() {}
    
    public func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    public func pop() {
        path.removeLast()
    }
}

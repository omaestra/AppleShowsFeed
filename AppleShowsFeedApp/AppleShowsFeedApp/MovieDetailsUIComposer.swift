//
//  MovieDetailsUIComposer.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 30/09/2025.
//

import SwiftUI

final class MovieDetailsUIComposer {
    static func composedWith(
        viewModel: MovieDetailsViewModel
    ) -> some View {
        MovieDetailsView(viewModel: viewModel)
    }
}

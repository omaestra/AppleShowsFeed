//
//  MoviesListView.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 24/09/2025.
//

import SwiftUI
import AppleShowsFeed

struct MoviesListView: View {
    @StateObject var viewModel: MoviesListViewModel
    
    init(viewModel: MoviesListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(viewModel.movies, id: \.id) { movie in
            MovieCellView(viewModel: movie)
                .onTapGesture {
                    movie.onSelection?()
                }
                .redacted(reason: viewModel.isLoading ? .placeholder : [])
                .disabled(viewModel.isLoading)
        }
        .listStyle(.plain)
        .overlay {
            if viewModel.isLoading, viewModel.movies.isEmpty {
                ProgressView("Loading awesome movies...")
            }
            if let error = viewModel.error {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                    Text(error.localizedDescription)
                }
                .foregroundStyle(.secondary)
                .padding()
            }
        }
    }
}

struct MovieCellView: View {
    let viewModel: MovieCellViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: viewModel.imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image(systemName: "movieclapper")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 100, height: 150)
            .background(Color.secondary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.name)
                    .font(.headline)
                    .lineLimit(2)

                Text(viewModel.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    if let rentalPrice = viewModel.rentalPrice {
                        HStack {
                            Text("Rent for:")
                                .fontWeight(.semibold)
                            Text(rentalPrice)
                        }
                    }
                    HStack {
                        Text("Buy for:")
                            .fontWeight(.semibold)
                        Text(viewModel.price)
                    }
                }
                .font(.footnote)
            }
            .frame(maxHeight: .infinity)
        }
        .frame(height: 150)
        .padding(.vertical, 8)
    }
}

#Preview("Happy path") {
    final class MockMoviesLoader: MovieLoader {
        func load() async throws -> [Movie] {
            [
                Movie(id: "id", name: "any name", summary: "any summary", title: "any title", releaseDate: .now, rights: "any rights", rentalPrice: nil, price: Price(label: "12.99$", amount: 12.99, currency: "USD"), artist: "any artist", category: "any category", contentType: .movie, images: [])
            ]
        }
    }
    
    let loader = MockMoviesLoader()
    let viewModel = MoviesListViewModel(loader: loader, onSelection: { _ in })
    
    return MoviesListView(viewModel: viewModel)
        .task {
            await viewModel.loadMovies()
        }
}

#Preview("Error state") {
    final class AlwaysFailingMoviesLoader: MovieLoader {
        func load() async throws -> [Movie] {
            throw NSError(domain: "any error", code: -1)
        }
    }
    
    let loader = AlwaysFailingMoviesLoader()
    let viewModel = MoviesListViewModel(loader: loader, onSelection: { _ in })
    
    return MoviesListView(viewModel: viewModel)
        .task {
            await viewModel.loadMovies()
        }
}

#Preview("Loading state") {
    final class AlwaysLoadingLoader: MovieLoader {
        func load() async throws -> [Movie] {
            try await Task.sleep(for: .seconds(4))
            return []
        }
    }
    
    let loader = AlwaysLoadingLoader()
    let viewModel = MoviesListViewModel(loader: loader, onSelection: { _ in })
    
    return MoviesListView(viewModel: viewModel)
        .task {
            await viewModel.loadMovies()
        }
}

extension Array where Element == MovieCellViewModel {
    static func mockData() -> [MovieCellViewModel] {
        [
            MovieCellViewModel(
                id: "1",
                imageURL: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video221/v4/d7/36/81/d736811f-fbe7-285c-c02a-1d746fdb523b/DIS_FANTASTIC_FOUR_FIRST_STEPS_ITUNES_ARTWORK_WW_ARTWORK_EN_2000x3000_508B2600000BMW.lsr/113x170bb.png"),
                name: "The Fantastic Four: First Steps",
                category: "Action & Adventure",
                rentalPrice: "12.99$",
                price: "21.99$"
            ),
            MovieCellViewModel(
                id: "2",
                imageURL: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video221/v4/b2/23/5c/b2235ced-ec7d-7dd5-e993-1d0a594baed2/MI8_CA_2000x3000.jpg/39x60bb.png"),
                name: "Mission: Impossible - The Final Reckoning",
                category: "Action & Adventure",
                rentalPrice: "9.99$",
                price: "12.99$"
            )
        ]
    }
}

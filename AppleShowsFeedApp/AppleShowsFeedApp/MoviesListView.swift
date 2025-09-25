//
//  MoviesListView.swift
//  AppleShowsFeedApp
//
//  Created by Oswaldo Maestra on 24/09/2025.
//

import SwiftUI
import AppleShowsFeed

struct MoviesListView: View {
    @ObservedObject var viewModel: MoviesListViewModel
    
    var body: some View {
        List(viewModel.movies, id: \.id) { movie in
            MovieCellView(movie: movie)
        }
        .listStyle(.plain)
    }
}

struct MovieCellView: View {
    let movie: Movie
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: movie.images.first?.url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image(systemName: "movieclapper")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 100, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                Text(movie.name)
                    .font(.headline)
                    .lineLimit(2)

                Text(movie.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Rent for:")
                            .fontWeight(.semibold)
                        Text(movie.rentalPrice.label)
                    }
                    HStack {
                        Text("Buy for:")
                            .fontWeight(.semibold)
                        Text(movie.price.label)
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

#Preview {
    MoviesListView(viewModel: MoviesListViewModel(movies: .mockData()))
}

extension Array where Element == Movie {
    static func mockData() -> [Movie] {
        [
            Movie(id: "1", name: "The Fantastic Four: First Steps", summary: "some summary", title: "The Fantastic Four: First Steps - Matt Shakman", releaseDate: .now, rights: "some rights", rentalPrice: Price(label: "12.99$", amount: 21.99, currency: "USD"), price: Price(label: "21.99$", amount: 21.99, currency: "USD"), artist: "some artist", category: "Action & Adventure", contentType: .movie, duration: 60, images: [
                ImageItem(url: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video221/v4/d7/36/81/d736811f-fbe7-285c-c02a-1d746fdb523b/DIS_FANTASTIC_FOUR_FIRST_STEPS_ITUNES_ARTWORK_WW_ARTWORK_EN_2000x3000_508B2600000BMW.lsr/113x170bb.png")!, attributes: .init(height: 20)),
            ]),
            Movie(id: "2", name: "Mission: Impossible - The Final Reckoning", summary: "other summary", title: "Mission: Impossible - The Final Reckoning - Christopher McQuarrie", releaseDate: .distantPast, rights: "some rights", rentalPrice: Price(label: "9.99$", amount: 9.99, currency: "USD"), price: Price(label: "12.99$", amount: 12.99, currency: "USD"), artist: "some other artist", category: "Action & Adventure", contentType: .movie, duration: 60, images: [
                ImageItem(url: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video221/v4/b2/23/5c/b2235ced-ec7d-7dd5-e993-1d0a594baed2/MI8_CA_2000x3000.jpg/39x60bb.png")!, attributes: .init(height: 20)),
            ])
        ]
    }
}

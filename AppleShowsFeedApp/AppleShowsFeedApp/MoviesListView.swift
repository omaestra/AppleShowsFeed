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
            MovieCellView(viewModel: movie)
        }
        .listStyle(.plain)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
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
    let viewModel = MoviesListViewModel()
    viewModel.didStartLoading()
    viewModel.didFinishLoading(with: .mockData())
    
    return MoviesListView(viewModel: viewModel)
}

#Preview("Error state") {
    let viewModel = MoviesListViewModel()
    viewModel.didStartLoading()
    viewModel.didFinishLoading(with: NSError(domain: "Oops", code: -1))
    
    return MoviesListView(viewModel: viewModel)
        .refreshable {
            viewModel.didFinishLoading(with: .mockData())
        }
}

#Preview("Loading state") {
    let viewModel = MoviesListViewModel()
    viewModel.didStartLoading()
    
    return MoviesListView(viewModel: viewModel)
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
